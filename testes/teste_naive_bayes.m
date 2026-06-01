fprintf('================================================\n');
fprintf('       TESTE: NAIVE BAYES CLASSIFIER            \n');
fprintf('================================================\n\n');

treino_orig = {'a inteligencia artificial evolui muito rapido', 'o futebol move milhoes de adeptos'};
treino_plag = {'copia inteligencia artificial evolui muito rapido', 'futebol move imensos milhoes'};

nb = naive_bayes_classifier();
nb = nb.train(treino_orig, treino_plag);
fprintf('-> Modelo treinado com sucesso.\n\n');

teste_normal = process_text('o futebol e um desporto maravilhoso');
teste_suspeito = process_text('copia fiavel sobre inteligencia artificial');

res_normal = nb.classify(nb, teste_normal);
res_suspeito = nb.classify(nb, teste_suspeito);

fprintf('Texto Normal (Esperado: 0) -> Obtido: %d\n', res_normal);
fprintf('Texto Suspeito (Esperado: 1) -> Obtido: %d\n', res_suspeito);