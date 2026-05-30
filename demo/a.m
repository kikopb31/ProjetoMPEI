clear; clc;

addpath('../modulos/minhash');
addpath('../modulos/bloom_filter');
addpath('../modulos/naive_bayes');
fprintf('================================================\n');
fprintf('      SISTEMA DE DETECCAO DE PLAGIO              \n');
fprintf('================================================\n\n');

current = fileparts(mfilename('fullpath'));
base_path = fullfile(current, '..', 'datasets');
pasta_originais = dir(fullfile(base_path, 'originais', '*.txt'));
pasta_plagios   = dir(fullfile(base_path, 'plagios', '*.txt'));

if isempty(pasta_originais) || isempty(pasta_plagios)
    error('Faltam ficheiros! Verifica as pastas originais e plagios.');
end

docs_originais = cell(1, length(pasta_originais));
docs_plagios   = cell(1, length(pasta_plagios));

for i = 1:length(pasta_originais)
    caminho = fullfile(pasta_originais(i).folder, pasta_originais(i).name);
    docs_originais{i} = process_text(fileread(caminho));
end


for i = 1:length(pasta_plagios)
    caminho = fullfile(pasta_plagios(i).folder, pasta_plagios(i).name);
    docs_plagios{i} = process_text(fileread(caminho));
end
fprintf('Carregados: %d originais, %d plagios\n', length(docs_originais), length(docs_plagios));

% Bloom Filter
bf = bloom_filter(2000, 4);
for i = 1:length(docs_originais)
    bf = bf.add(docs_originais{i}, bf);
end


% Naive Bayes
nb = naive_bayes_classifier();
nb = nb.train(docs_originais, docs_plagios);


% MinHash
k_shingle = 2;
num_hashes = 200;
H = hash_family(num_hashes);

assinaturas_base = zeros(num_hashes, length(docs_originais));
for i = 1:length(docs_originais)
    sh_base = generate_shingles(docs_originais{i}, k_shingle);
    assinaturas_base(:, i) = minhash_signature(sh_base, H).';
end
fprintf('Modulos inicializados.\n\n');

%% Analise dos documentoa

texto_teste = 'A inteligencia artificial tem evoluido de forma acelerada ao longo da ultima decada, impulsionada pelo aumento da capacidade computacional.';
fprintf('Texto a analisar:\n%s\n\n', texto_teste);
texto_processado = process_text(texto_teste);

% Bloom Filter
fprintf('[1/3] A verificar copia exata...\n');
if bf.check(texto_processado, bf)
    fprintf('Resultado: PLAGIO (copia exata)\n');
    return;
else
    fprintf('Resultado: ok\n\n');
end


% Naive Bayes
fprintf('[2/3] Analise de estilo...\n');
suspeito_nb = nb.classify(nb, texto_processado);
if suspeito_nb
    fprintf('Resultado: suspeito\n\n');
else
    fprintf('Resultado: normal\n\n');
end

% MinHash
fprintf('[3/3] Calculo de similaridade...\n');
sh_teste = generate_shingles(texto_processado, k_shingle);
sig_teste = minhash_signature(sh_teste, H);

maior_sim = 0;
id_doc = 0;
for i = 1:length(docs_originais)
    sim = jaccard_estimate(sig_teste, assinaturas_base(:, i));
    if sim > maior_sim
        maior_sim = sim;
        id_doc = i;
    end
end
fprintf('Similaridade maxima: %.0f%%\n', maior_sim * 100);
if id_doc > 0
    fprintf('Ficheiro mais parecido: %s\n\n', pasta_originais(id_doc).name);
end


%% 4. Veredito
fprintf('================================================\n');
fprintf('                  VEREDITO                      \n');
fprintf('================================================\n');

if maior_sim > 0.25
    fprintf('STATUS: PLAGIO PARCIAL\n');
    fprintf('Similaridade de %.0f%% com %s (acima do limite de 25%%)\n', ...
            maior_sim * 100, pasta_originais(id_doc).name);
    
elseif suspeito_nb
    fprintf('STATUS: ATENCAO\n');
    fprintf('O texto apresenta um estilo suspeito, mesmo com pouca similaridade (%.0f%%)\n', maior_sim * 100);
    
else
    fprintf('STATUS: ORIGINAL\n');
    fprintf('O documento passou com sucesso em todos os testes\n');
end