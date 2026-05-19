clear; clc;

% Parâmetros
k = 2;              
numHashes = 500;   

% Ler documentos
current = fileparts(mfilename('fullpath'));
base = fullfile(current, '..', 'datasets');
text1 = fileread(fullfile(base, 'originais', 'orig1.txt'));
text2 = fileread(fullfile(base, 'plágios', 'orig1_plag1.txt'));

% Processar texto
text1 = process_text(text1);
text2 = process_text(text2);

% Gerar shingles
sh1 = generate_shingles(text1, k);
sh2 = generate_shingles(text2, k);

% Criar funções hash
H = hash_family(numHashes, 1e6);

% Gerar assinaturas
sig1 = minhash_signature(sh1, H);
sig2 = minhash_signature(sh2, H);

% Similaridade estimada
sim = jaccard_estimate(sig1, sig2);

fprintf('Similaridade estimada entre orig1 e orig1_plag1: %.4f\n', sim);
