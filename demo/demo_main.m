fprintf('================================================\n');
fprintf('      SISTEMA DE DETECCAO DE PLAGIO              \n');
fprintf('================================================\n\n');

current = fileparts(mfilename('fullpath'));
base_path = fullfile(current, '..', 'datasets');
pasta_originais = dir(fullfile(base_path, 'originais', '*.txt'));
pasta_plagios   = dir(fullfile(base_path, 'plagios', '*.txt'));

if isempty(pasta_originais) || isempty(pasta_plagios)
    error(' Verifica as pastas originais e plagios.Faltam ficheiros!');
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
fprintf('Modulos inicializados com sucesso.\n\n');


texto_teste = 'A inteligencia artificial tem evoluido de forma acelerada ao longo da ultima decada, impulsionada pelo aumento da capacidade computacional.';
fprintf('Texto a analisar:\n"%s"\n\n', texto_teste);
texto_processado = process_text(texto_teste);


fprintf('A verificar Bloom Filter ...\n');
copia_exata = bf.check(texto_processado, bf);
if copia_exata
    fprintf('Resultado: Identificada correspondencia exata no Filtro!\n\n');
else
    fprintf('Resultado: Nenhuma copia encontrada.\n\n');
end

fprintf(' Analise de Naive Bayes...\n');
suspeito_nb = nb.classify(nb, texto_processado);
if suspeito_nb
    fprintf('Resultado: Estilo classificado como SUSPEITO (proximo de IA/Plagio)\n\n');
else
    fprintf('Resultado: Estilo classificado como NORMAL (Original)\n\n');
end


fprintf(' Calculo de MinHash... \n');
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

if id_doc > 0
    fprintf('Ficheiro original mais parecido: %s\n', pasta_originais(id_doc).name);
    fprintf('Similaridade estimada de Jaccard: %.0f%%\n\n', maior_sim * 100);
else
    fprintf('Nenhuma similaridade encontrada.\n\n');
end


fprintf('================================================\n');
fprintf('                  VEREDITO                      \n');
fprintf('================================================\n');

if copia_exata
    fprintf('STATUS: PLAGIO DETETADO (Copia Exata)\n');
    fprintf('Os resultados obtidos pelo Bloom Filter mostram que o texto coincide com a base de dados.\n');
    if id_doc > 0
        fprintf('Similaridade MinHash: %.0f%% com %s\n', maior_sim * 100, pasta_originais(id_doc).name);
    end

elseif maior_sim > 0.25
    fprintf('STATUS: PLAGIO PARCIAL\n');
    fprintf('Similaridade de %.0f%% com %s (acima do limite seguro de 25%%).\n', ...
            maior_sim * 100, pasta_originais(id_doc).name);
    
elseif suspeito_nb
    fprintf('STATUS: ALERTA DE ESTILO \n');
    fprintf('O Naive Bayes detetou um padrao de escrita suspeito, embora a similaridade de Jaccard seja baixa (%.0f%%).\n', maior_sim * 100);
    
else
    fprintf('STATUS: DOCUMENTO ORIGINAL\n');
    fprintf('O documento passou com sucesso em todos os filtros de verificacao.\n');
end