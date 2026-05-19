clear; clc;

% Parâmetros
k = 2;              
numHashes = 500;   

current = fileparts(mfilename('fullpath'));
base = fullfile(current, '..', 'datasets');

% Listar documentos
originais = dir(fullfile(base, 'originais', '*.txt'));
plagios   = dir(fullfile(base, 'plagios', '*.txt'));

% Juntar tudo numa lista única
todos = [originais; plagios];
numDocs = length(todos);

fprintf("Foram encontrados %d documentos.\n\n", numDocs);

% Pré-processar e gerar shingles
docs = cell(1, numDocs);
shingles = cell(1, numDocs);
for i = 1:numDocs
    path = fullfile(todos(i).folder, todos(i).name);
    txt = fileread(path);
    txt = process_text(txt);              
    docs{i} = txt;
    shingles{i} = generate_shingles(txt, k);
end

% Criar funções hash
H = hash_family(numHashes, 1e6);

% Gerar assinaturas MinHash
signatures = zeros(numHashes, numDocs);
for i = 1:numDocs
    signatures(:, i) = minhash_signature(shingles{i}, H);
end

% Calcular matriz de similaridade
simMatrix = zeros(numDocs);
for i = 1:numDocs
    for j = i:numDocs
        sim = jaccard_estimate(signatures(:, i), signatures(:, j));
        simMatrix(i, j) = sim;
        simMatrix(j, i) = sim;
    end
end

% Mostrar matriz
disp("=== MATRIZ DE SIMILARIDADE (MinHash) ===");
disp(simMatrix);

% Listar pares mais semelhantes
fprintf("\n=== TOP 10 PARES MAIS SEMELHANTES ===\n");

pares = [];

for i = 1:numDocs
    for j = i+1:numDocs
        pares = [pares; i, j, simMatrix(i, j)];
    end
end

% Ordenar por similaridade
pares = sortrows(pares, -3);

for k = 1:min(10, size(pares,1))
    i = pares(k,1);
    j = pares(k,2);
    fprintf("%s  <->  %s   | Similaridade = %.4f\n", ...
        todos(i).name, todos(j).name, pares(k,3));
end
