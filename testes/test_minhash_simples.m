clear; clc;

k = 2;              
numHashes = 500;   

current = fileparts(mfilename('fullpath'));
base = fullfile(current, '..', 'datasets');
text1 = fileread(fullfile(base, 'originais', 'orig1.txt'));
text2 = fileread(fullfile(base, 'plagios', 'orig1_plag1.txt'));

text1 = process_text(text1);
text2 = process_text(text2);

sh1 = generate_shingles(text1, k);
sh2 = generate_shingles(text2, k);

H = hash_family(numHashes);

sig1 = minhash_signature(sh1, H);
sig2 = minhash_signature(sh2, H);

sim = jaccard_estimate(sig1, sig2);

fprintf('Similaridade estimada entre orig1 e orig1_plag1: %.4f\n', sim);
