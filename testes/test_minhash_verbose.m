clear; clc;

% Parâmetros
k = 3;
numHashes = 20;   % menos hashes para poderes ver tudo

% Ler documentos
text1 = fileread('../datasets/originais/orig1.txt');
text2 = fileread('../datasets/plagiados/orig1_plag1.txt');

fprintf("=== DOCUMENTO 1 ===\n%s\n\n", text1);
fprintf("=== DOCUMENTO 2 ===\n%s\n\n", text2);

% Gerar shingles
sh1 = generate_shingles(text1, k);
sh2 = generate_shingles(text2, k);

fprintf("=== SHINGLES DOC 1 ===\n");
disp(sh1');

fprintf("=== SHINGLES DOC 2 ===\n");
disp(sh2');

% Criar funções hash
H = hash_family(numHashes, 1e6);

fprintf("=== HASHES GERADOS ===\n");
for i = 1:numHashes
    fprintf("Hash %d: a*x + b mod p\n", i);
end
fprintf("\n");

% Gerar assinaturas
sig1 = minhash_signature(sh1, H);
sig2 = minhash_signature(sh2, H);

fprintf("=== ASSINATURA DOC 1 ===\n");
disp(sig1);

fprintf("=== ASSINATURA DOC 2 ===\n");
disp(sig2);

% Similaridade estimada
sim = jaccard_estimate(sig1, sig2);

fprintf("\n=== SIMILARIDADE FINAL ===\n");
fprintf("Similaridade estimada: %.4f\n", sim);
