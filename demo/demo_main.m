clear all; clc;

fprintf('================================================\n');
fprintf('      SISTEMA DE DETECCAO DE PLAGIO              \n');
fprintf('================================================\n\n');

current = fileparts(mfilename('fullpath'));
base_path = fullfile(current, '..', 'datasets');
pasta_originais = dir(fullfile(base_path, 'originais', '*.txt'));
pasta_plagios   = dir(fullfile(base_path, 'plagios', '*.txt'));

if isempty(pasta_originais) || isempty(pasta_plagios)
    error('Verifica as pastas originais e plagios. Faltam ficheiros!');
end

docs_originais = cell(1, length(pasta_originais));
for i = 1:length(pasta_originais)
    caminho = fullfile(pasta_originais(i).folder, pasta_originais(i).name);
    docs_originais{i} = process_text(fileread(caminho));
end

docs_plagios = cell(1, length(pasta_plagios));
for i = 1:length(pasta_plagios)
    caminho = fullfile(pasta_plagios(i).folder, pasta_plagios(i).name);
    docs_plagios{i} = process_text(fileread(caminho));
end

fprintf('-> [Setup] Carregados: %d originais e %d plágios.\n', ...
    length(docs_originais), length(docs_plagios));


bf = bloom_filter(2000, 4);
for i = 1:length(docs_originais)
    bf = bf.add(docs_originais{i}, bf);
end

nb = naive_bayes_classifier();
nb = nb.train(docs_originais, docs_plagios);

k_shingle = 2;
num_hashes = 200;
H = hash_family(num_hashes);

assinaturas_base = zeros(num_hashes, length(docs_originais));
for i = 1:length(docs_originais)
    sh_base = generate_shingles(docs_originais{i}, k_shingle);
    assinaturas_base(:, i) = minhash_signature(sh_base, H).';
end
fprintf('-> [Módulos] Bloom Filter, Naive Bayes e MinHash inicializados.\n\n');

fprintf('================================================================\n');
fprintf('                 INICIANDO MATRIZ DE TESTES CONJUNTOS           \n');
fprintf('================================================================\n\n');

total_testes = length(docs_plagios);
detecoes_bloom = 0;
detecoes_minhash = 0;
alertas_estilo = 0;

tic; 

for t = 1:total_testes
    nome_ficheiro = pasta_plagios(t).name;
    texto_processado = docs_plagios{t};
    
    fprintf('A analisar documento [%d/%d]: %s...\n', t, total_testes, nome_ficheiro);
    
    % --- TESTE 1: Bloom Filter ---
    copia_exata = bf.check(texto_processado, bf);
    
    % --- TESTE 2: Naive Bayes ---
    suspeito_nb = nb.classify(nb, texto_processado);

    % --- TESTE 3: MinHash & Similaridade Jaccard ---
    sh_teste = generate_shingles(texto_processado, k_shingle);
    sig_teste = minhash_signature(sh_teste, H).';

    maior_sim = 0;
    id_doc_parecido = 0; 

    for i = 1:length(docs_originais)
        sim = jaccard_estimate(sig_teste, assinaturas_base(:, i));
        if sim > maior_sim
            maior_sim = sim;
            id_doc_parecido = i;
        end
    end
    
    if copia_exata
        fprintf('  [VEREDITO] -> STATUS: PLÁGIO DETETADO (Cópia Exata via Bloom Filter)\n');
        if maior_sim > 0 && id_doc_parecido > 0
            fprintf('                Ficheiro Alvo: %s (Similaridade Jaccard: %.0f%%)\n', ...
                pasta_originais(id_doc_parecido).name, maior_sim * 100);
        else
            fprintf('                Correspondência exata na base de dados.\n');
        end
        detecoes_bloom = detecoes_bloom + 1;
        
    elseif maior_sim > 0.25
        fprintf('  [VEREDITO] -> STATUS: PLÁGIO PARCIAL DETETADO (via MinHash)\n');
        fprintf('                Ficheiro Alvo: %s | Similaridade Jaccard: %.0f%%\n', ...
            pasta_originais(id_doc_parecido).name, maior_sim * 100);
        detecoes_minhash = detecoes_minhash + 1;
        
    elseif suspeito_nb
        fprintf('  [VEREDITO] -> STATUS: ALERTA DE ESTILO (via Naive Bayes)\n');
        if maior_sim > 0 && id_doc_parecido > 0
            fprintf('                Padrão suspeito. Jaccard máximo: %.0f%% com %s\n', ...
                maior_sim * 100, pasta_originais(id_doc_parecido).name);
        else
            fprintf('                Padrão gramatical suspeito detetado.\n');
        end
        alertas_estilo = alertas_estilo + 1;
        
    else
        fprintf('  [VEREDITO] -> STATUS: DOCUMENTO ORIGINAL\n');
    end
    fprintf('----------------------------------------------------------------\n');
end

tempo_total = toc;

fprintf('\n================================================================\n');
fprintf('                      MÉTRICAS DE DESEMPENHO                    \n');
fprintf('================================================================\n');
fprintf('Tempo total gasto nos testes: %.4f segundos\n', tempo_total);
fprintf('Total de documentos suspeitos analisados: %d\n', total_testes);
fprintf('Cópias Exatas intercetadas pelo Bloom Filter: %d (%.1f%%)\n', ...
    detecoes_bloom, (detecoes_bloom/total_testes)*100);
fprintf('Plágios Parciais apanhados pelo MinHash (>25%%): %d (%.1f%%)\n', ...
    detecoes_minhash, (detecoes_minhash/total_testes)*100);
fprintf('Alertas de tom/estilo gerados pelo Naive Bayes: %d (%.1f%%)\n', ...
    alertas_estilo, (alertas_estilo/total_testes)*100);

total_detetado = detecoes_bloom + detecoes_minhash + alertas_estilo;
fprintf('Taxa Global de Deteção de Irregularidades: %.1f%%\n', ...
    (total_detetado / total_testes) * 100);
fprintf('================================================================\n');