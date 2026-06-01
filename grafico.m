% Dados do meu terminal
num_hashes = [50, 100, 200, 500];
tempos     = [0.9952, 1.4451, 3.0581, 7.6423];
erros_med  = [0.0144, 0.0097, 0.0065, 0.0037];

figure('Name', 'Avaliação de Desempenho do MinHash', 'NumberTitle', 'off');

% Gráfico de Evolução do Erro Médio
subplot(1, 2, 1);
plot(num_hashes, erros_med, '-o', 'LineWidth', 2, 'Color', [0.85 0.33 0.1], 'MarkerFaceColor', [0.85 0.33 0.1]);
grid on;
title('Evolução do Erro Médio');
xlabel('Número de Funções de Hash (k)');
ylabel('Erro Médio (vs Jaccard Real)');
xticks(num_hashes);


% Gráfico de Tempo de Processamento
subplot(1, 2, 2);
bar(num_hashes, tempos, 'FaceColor', [0 0.45 0.74]);
grid on;
title('Tempo de Execução');
xlabel('Número de Funções de Hash (k)');
ylabel('Tempo de Processamento (segundos)');
set(gcf, 'Position', [100, 100, 1000, 450]);