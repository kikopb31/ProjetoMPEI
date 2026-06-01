% Ficheiro: testes/teste_bloom_filter.m

fprintf('================================================\n');
fprintf('       TESTE: FILTRO DE BLOOM                   \n');
fprintf('================================================\n\n');

bf = bloom_filter(2000, 4);

doc1 = 'A inteligencia artificial tem passado por um crescimento notavel';
doc2 = 'O desenvolvimento da inteligencia artificial tornou-se um fenomeno';
doc3 = 'Este texto e completamente original e nao foi registado';

bf = bf.add(process_text(doc1), bf);
bf = bf.add(process_text(doc2), bf);
fprintf('-> Os elements foram registados com sucesso no filtro.\n\n');

verif1 = bf.check(process_text(doc1), bf);
verif2 = bf.check(process_text(doc2), bf);
verif3 = bf.check(process_text(doc3), bf);

fprintf('Verificacao doc1 (Esperado: 1) -> Obtido: %d\n', verif1);
fprintf('Verificacao doc2 (Esperado: 1) -> Obtido: %d\n', verif2);
fprintf('Verificacao doc3 (Esperado: 0) -> Obtido: %d\n\n', verif3);

falsos_positivos = 0;
num_testes = 1000;
letras = 'abcdefghijklmnopqrstuvwxyz ';

for i = 1:num_testes
    % CORREÇÃO: Alterado num_length para length
    idx = randi(length(letras), 1, 20); 
    str_aleatoria = letras(idx);
    
    if bf.check(str_aleatoria, bf)
        falsos_positivos = falsos_positivos + 1;
    end
end

tx_fp = (falsos_positivos / num_testes) * 100;
fprintf('Numero de Falsos Positivos em %d strings aleatorias: %d (%.2f%%)\n', ...
    num_testes, falsos_positivos, tx_fp);