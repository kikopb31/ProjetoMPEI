%% SETUP DO PROJETO MPEI – DETEÇÃO DE PLÁGIO
clear; clc;

fprintf("=== SETUP DO PROJETO MPEI ===\n\n");

%% 1. Descobrir a pasta raiz do projeto
root = fileparts(mfilename('fullpath'));
fprintf("Pasta do projeto: %s\n\n", root);

%% 2. Adicionar todas as subpastas ao MATLAB path
addpath(genpath(root));
fprintf("✔ Todas as subpastas adicionadas ao path.\n");

%% 3. Validar estrutura de pastas
pastas = {
    fullfile(root, 'datasets')
    fullfile(root, 'datasets', 'originais')
    fullfile(root, 'datasets', 'plagios')
    fullfile(root, 'modulos')
    fullfile(root, 'modulos', 'minhash')
    fullfile(root, 'modulos', 'bloom_filter')
    fullfile(root, 'modulos', 'naive_bayes')
    fullfile(root, 'testes')
};

fprintf("\n=== Verificação de pastas ===\n");
for i = 1:length(pastas)
    if isfolder(pastas{i})
        fprintf("✔ %s\n", pastas{i});
    else
        fprintf("✘ FALTA: %s\n", pastas{i});
    end
end

%% 4. Validar funções 
funcoes = {
    'generate_shingles'
    'hash_family'
    'minhash_signature'
    'jaccard_estimate'
    'process_text'
    'bloom_filter'
    'naive_bayes_classifier'
};

fprintf("\n=== Verificação de funções ===\n");
for i = 1:length(funcoes)
    caminho = which(funcoes{i});
    if isempty(caminho)
        fprintf("✘ Função NÃO encontrada: %s\n", funcoes{i});
    else
        fprintf("✔ %s -> %s\n", funcoes{i}, caminho);
    end
end

%% 5. Guardar o path
savepath;
fprintf("\n✔ Path guardado permanentemente.\n");
fprintf("\n=== SETUP CONCLUÍDO COM SUCESSO ===\n");
