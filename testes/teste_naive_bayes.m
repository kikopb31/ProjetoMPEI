addpath('../modulos/naive_bayes');
addpath('../modulos/minhash'); 

textos_originais_brutos = {
    'O estudo da biodiversidade é fundamental para compreender os ecossistemas',
    'a energia solar expandiu se devido a queda continua dos custos de fabrico',
    'a culinaria italiana e reconhecida mundialmente pela sua simplicidade'
};

textos_plagio_brutos = {
    'nas ultimas decadas a inteligencia artificial tem passado por crescimento notavel',
    'o desenvolvimento da inteligencia artificial tornou-se uma das maiores evoluções tecnológicas',
    'a energia solar tem vindo a destacar-se como uma das alternativas de energia renovável'
};

textos_originais = cellfun(@process_text, textos_originais_brutos, 'UniformOutput', false);
textos_plagio = cellfun(@process_text, textos_plagio_brutos, 'UniformOutput', false);

nb = naive_bayes_classifier();
nb = nb.train(textos_originais, textos_plagio);
fprintf('-> Modelo Naïve Bayes treinado com %d instâncias.\n\n', length(textos_originais) + length(textos_plagio));


teste_ok = process_text('a culinaria italiana foca em ingredientes frescos e simplicidade');
teste_suspeito = process_text('desenvolvimento e crescimento notavel de fenomenos tecnologicos');
res_ok = nb.classify(nb, teste_ok);
res_suspeito = nb.classify(nb, teste_suspeito);

fprintf('Texto1 (Estilo Original) -> Classificação de Plágio? (Esperado: 0) -> Obtido: %d\n', res_ok);
fprintf('Texto2 (Estilo Plágio) -> Classificação de Plágio? (Esperado: 1) -> Obtido: %d\n', res_suspeito);