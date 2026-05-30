addpath('../modulos/bloom_filter');
addpath('../modulos/minhash'); 

bf = bloom_filter(500, 3);

doc1 = process_text('A inteligência artificial tem evoluído a um ritmo muito mais acelerado');
doc2 = process_text('A energia solar tornou-se uma das principais fontes de energia renovável');

bf = bf.add(doc1, bf);
bf = bf.add(doc2, bf);
fprintf('-> Os elementos foram registados com sucesso no filtro.\n\n');

verif_1 = bf.check(doc1, bf);
verif_2 = bf.check(doc2, bf);

doc_falso = process_text('O futebol é um desporto que desperta muita paixão');
verif_falso = bf.check(doc_falso, bf);
fprintf('Verificação doc1 (Esperado: 1) -> Obtido: %d\n', verif_1);
fprintf('Verificação doc2 (Esperado: 1) -> Obtido: %d\n', verif_2);
fprintf('Verificação doc3 (Esperado: 0) -> Obtido: %d\n\n', verif_falso);


falsos_positivos = 0;
num_testes = 1000;
for i = 1:num_testes
    str_aleatoria = char(randi([97, 122], 1, 8)); 
    if bf.check(str_aleatoria, bf)
        falsos_positivos = falsos_positivos + 1;
    end
end

taxa = (falsos_positivos / num_testes) * 100;
fprintf('Número de Falsos Positivos em %d strings aleatórias: %d (%.2f%%)\n', num_testes, falsos_positivos, taxa);