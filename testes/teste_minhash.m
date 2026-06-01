% Ficheiro: testes/teste_minash.m
clear all; clc;

k_shingle = 2; 
numHashes_testes = [50, 100, 200, 500]; 

current = fileparts(mfilename('fullpath'));
base = fullfile(current, '..', 'datasets');

originais = dir(fullfile(base, 'originais', '*.txt'));
plagios   = dir(fullfile(base, 'plagios', '*.txt'));

todos = [originais; plagios];
numDocs = length(todos);

fprintf("Foram encontrados %d documentos para o teste.\n\n", numDocs);

docs = cell(1, numDocs);
shingles = cell(1, numDocs);
for i = 1:numDocs
    path = fullfile(todos(i).folder, todos(i).name);
    txt = fileread(path);
    txt = process_text(txt);
    docs{i} = txt;
    shingles{i} = generate_shingles(txt, k_shingle);
end

realSim = zeros(numDocs);
for i = 1:numDocs
    for j = i:numDocs
        if i == j
            realSim(i,j) = 1;
        else
            intersect_size = length(intersect(shingles{i}, shingles{j}));
            union_size = length(union(shingles{i}, shingles{j}));
        
            if union_size == 0
                sim = 0;
            else
                sim = intersect_size / union_size;
            end
            
            realSim(i, j) = sim;
            realSim(j, i) = sim; 
        end
    end
end

fprintf("\n=== INÍCIO DA AVALIAÇÃO MINHASH ===\n");

for numHashes = numHashes_testes
    fprintf("\n[Teste] %d funções de dispersão:\n", numHashes);

    % CORREÇÃO: Adicionado tic para iniciar o cronómetro
    tic; 
    
    H = hash_family(numHashes);

    signatures = zeros(numHashes, numDocs);
    for i = 1:numDocs
        signatures(:, i) = minhash_signature(shingles{i}, H).';
    end
    
    estSim = zeros(numDocs);
    for i = 1:numDocs
        for j = i:numDocs
            if i == j
                sim = 1;
            else
                sim = jaccard_estimate(signatures(:, i), signatures(:, j));
            end
            estSim(i, j) = sim;
            estSim(j, i) = sim;
        end
    end
    
    tempo_execucao = toc; 

    erroTotal = 0;
    contagemPares = 0;
    for i = 1:numDocs
        for j = i+1:numDocs
            erroTotal = erroTotal + abs(realSim(i,j) - estSim(i,j));
            contagemPares = contagemPares + 1;
        end
    end
    erroMedio = erroTotal / contagemPares;

    fprintf(" -> Tempo de processamento: %.4f segundos\n", tempo_execucao);
    fprintf(" -> Erro Medio (vs Jaccard Real): %.4f\n", erroMedio);

    if numHashes == numHashes_testes(end)
        fprintf("\n=== TOP 10 PARES MAIS SEMELHANTES ===\n");
        
        numPares = numDocs * (numDocs - 1) / 2;
        pares = zeros(numPares, 3);
        idx = 1;
        
        for i = 1:numDocs
            for j = i+1:numDocs
                pares(idx, :) = [i, j, estSim(i, j)];
                idx = idx + 1;
            end
        end
        
        pares = sortrows(pares, -3);
        
        for p = 1:min(10, size(pares,1))
            id_1 = pares(p,1);
            id_2 = pares(p,2);
            est = pares(p,3);
            real = realSim(id_1, id_2);
            
            fprintf("%-15s <-> %-15s | Est: %.4f (Real: %.4f) | Erro: %.4f\n", ...
                todos(id_1).name, todos(id_2).name, est, real, abs(est-real));
        end
    end
end
