clear; clc;

% Parâmetros
k = 3;              % tamanho dos shingles
numHashes = 100;    % número de funções hash

% Ler documentos
text1 = fileread('../datasets/originais/orig1.txt');
text2 = fileread('../datasets/plagiados/orig1_plag1.txt');

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
