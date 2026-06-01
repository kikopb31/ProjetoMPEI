# RELATÓRIO DE PROJETO: SISTEMA DE DETEÇÃO DE PLÁGIO
**Unidade Curricular:** Métodos Probabilísticos para Engenharia Informática (MPEI)  
**Curso:** Licenciatura em Engenharia Informática (LEI)  
**Ano Letivo:** 2025/2026  

**Membros do Grupo (Turma Prática):**
| Nome | Nº Mec |
|------|--------|
| Cristiane Moreno | 128076 | 
| Francisco Baptista| 124677 |

---

## 1. INTRODUÇÃO E ARQUITETURA DO SISTEMA

O presente documento descreve o desenvolvimento, teste e avaliação de um sistema de deteção de plágio em documentos de texto. O objetivo central do projeto consiste em aplicar, de forma integrada, conceitos fundamentais de estruturas de dados probabilísticas, classificadores bayes e estimadores de similaridade num cenário real.

Para maximizar a eficiência computacional e a escalabilidade perante grandes volumes de dados, o sistema adota uma arquitetura de filtragem em três camadas sequenciais:
1. **Filtro de Bloom (*Bloom Filter*):** Uma primeira linha de defesa encarregue de intercetar de forma instantânea cópias exatas de ficheiros já registados na base de dados.
2. **Classificador Naïve Bayes:** Um módulo estatístico focado na análise estilística e de frequência de vocabulário, apto a detetar correspondências de autoria e padrões de escrita suspeitos.
3. **Módulo MinHash:** Um estimador matemático projetado para calcular a similaridade de Jaccard, permitindo a identificação de plágio parcial, paráfrases ou documentos com alterações ligeiras.

---

## 2. PRÉ-PROCESSAMENTO DE DADOS

Para garantir que as análises incidem estritamente sobre o conteúdo  dos textos , todos os documentos (originais e plagiados) são submetidos a um pipeline uniforme de normalização:
* **Conversão para Minúsculas:** Transformação de todos os caracteres do texto para letras minúsculas.
* **Remoção de Pontuação:** Eliminação de símbolos, pontuação e caracteres especiais através de expressões regulares.
* **Normalização de Espaços:** Supressão de espaços em branco redundantes, tabulações e quebras de linha consecutivas, reduzindo o texto a uma sequência limpa de termos.

---

## 3. GUIA DE EXECUÇÃO DOS PROGRAMAS

A estrutura do projeto foi organizada separando os modulos entre si, os testes, os datasets, a documentação e a demo.

### 3.1. Configuração e Inicialização do Ambiente
Antes de correr qualquer funcionalidade no ambiente **MATLAB**, é aconselhado preparar os paths dos ficheiros:
1. Abra o MATLAB e mude o diretório atual para a pasta raiz do projeto.
2. Execute o seguinte comando na Consola para carregar as subpastas e dependências:
   ```matlab
   setup
   ```

### 3.2. Execução dos Testes Isolados dos Módulos
Cada componente pode ser validada de forma autónoma através dos respetivos programas de teste, essenciais para a verificação do comportamento matemático e das métricas de erro:
* **Validar o Filtro de Bloom:**
  ```matlab
  teste_bloom_filter
  ```
* **Validar o Classificador Naïve Bayes:**
  ```matlab
  teste_naive_bayes
  ```
* **Validar o Estimador MinHash e Métricas:**
  ```matlab
  teste_minhash
  ```
* **Visualizar a Análise Gráfica do MinHash:**
  ```matlab
  grafico
  ```

### 3.3. Execução da Aplicação de Uso Conjunto
Para poder testar as funcionalidades do projeto num todo basta correr isto no terminal:
```matlab
demo_main
```

---

## 4. APRESENTAÇÃO E ANÁLISE DOS RESULTADOS DOS TESTES

Os testes foram desenhados com base nos guiões práticos e estendidos para aferir os limites operacionais de cada algoritmo.

### 4.1. Resultados: Filtro de Bloom
O Filtro de Bloom foi parametrizado com um vetor de bits de tamanho $m = 2000$ e recorre a $k = 4$ funções de dispersão (*hash*) independentes.
* **Metodologia de Teste:** O filtro foi populado com as assinaturas dos documentos originais conhecidos. Subsequentemente, foi submetido a uma bateria de testes contendo $1000$ cadeias de texto aleatórias e não pertencentes ao repositório para medir a incidência de falsos positivos.
* **Análise:** O módulo não registou qualquer ocorrência de falso positivo durante os testes práticos (taxa de erro obtida de **0.00%**). Matematicamente, a escolha de $k=4$ provou ser o ponto de equilíbrio ideal para o tamanho $m$ estipulado, distribuindo os bits de forma homogénea sem saturar a estrutura de dados precocemente, cumprindo o seu papel de triagem imediata.

### 4.2. Resultados: Classificador Naïve Bayes
O classificador foi treinado de raiz recorrendo a uma abordagem baseada em frequência de termos (*Bag-of-Words*).
* **Metodologia de Teste:** Utilizou-se uma base de treino simétrica constituída por 6 documentos perfeitamente originais e 6 documentos contendo plágios deliberados. O teste isolado avaliou a classificação de frases neutras e de frases construídas com o vocabulário enviesado da amostra de plágio.
* **Análise:** Através da incorporação da **Suavização de Laplace** ($\alpha = 1$), o algoritmo anulou com sucesso a problemática das probabilidades nulas para termos ausentes no treino. A transposição das operações probabilísticas para a **escala logarítmica** impossibilitou a ocorrência de *underflow* numérico. Nos testes de validação, o modelo categorizou com precisão absoluta as frases de controlo, distinguindo com segurança sequências normais de sequências com forte pendor de plágio.

### 4.3. Resultados: MinHash e Estimativa de Jaccard
A análise por MinHash baseou-se na fragmentação prévia dos textos normalizados em *shingles* de tamanho $k = 2$ palavras. O algoritmo foi submetido a testes de carga variando o número de funções de dispersão (50, 100, 200 e 500) para mapear o impacto na precisão e no tempo de computação.

| Número de Funções de Hash | Tempo de Execução Médio (s) | Erro Médio Absoluto (vs. Jaccard Real) |
|:---:|:---:|:---:|
| **50** | 0.4300 s | 0.0140 |
| **100** | 0.8878 s | 0.0104 |
| **200** | 1.4574 s | 0.0065 |
| **500** | 4.2315 s | 0.0032 |

* **Análise:** Os resultados experimentais validam diretamente o teorema central do MinHash: o aumento do número de funções de dispersão induz uma convergência estocástica em que o erro médio decresce substancialmente, aproximando a assinatura da verdadeira semelhança de Jaccard. Contudo, o custo temporal escala de forma linear. Com base na tabela obtida, o valor de **200 funções de hash** foi o selecionado para a solução final, dado que garante um erro residual desprezável (cerca de 0.65%) mantendo uma resposta ágil de 1.45 segundos.

---

## 5. DESCRIÇÃO DA APLICAÇÃO DE USO CONJUNTO

O programa principal `demo_main` unifica de forma coerente os três módulos independentes numa pipeline de decisão hierárquica e otimizada, simulando um ambiente real de auditoria académica. O fluxo lógico de processamento de um documento suspeito obedece às seguintes etapas estanques:

1. **Filtro de Bloom (Camada de Descarte Ultra-Rápido):** O documento sofre pré-processamento e o seu identificador é testado no filtro. Caso acuse positivo, o sistema interrompe imediatamente as restantes computações e emite o veredito: **PLÁGIO CONFIRMADO (Cópia Exata)**.
2. **MinHash (Camada de Similaridade Estrutural):** Se o documento não for uma cópia integral, o sistema extrai os seus *shingles* e gera a respetiva assinatura de MinHash, comparando-a com as assinaturas da base de dados. Foi definido um limiar de decisão (*threshold*) empírico de $25\%$. Se a similaridade calculada ultrapassar este valor, o sistema emite o veredito: **PLÁGIO PARCIAL DETETADO**, mapeando e exibindo explicitamente o documento original de origem.
3. **Naïve Bayes (Camada Comportamental e Estilística):** Se a semelhança literal se situar abaixo dos $25\%$, o documento é processado pelo classificador bayesiano para aferir a densidade e o padrão do vocabulário. Se a probabilidade calculada for significativamente favorável à classe de plágio, o sistema emite um: **ALERTA DE ANOMALIA ESTILÍSTICA (Suspeita de Cópia por Paráfrase)**.
4. **Veredito de Integridade:** Caso o documento passe incólume pelas três camadas de escrutínio, é homologado com o veredito: **DOCUMENTO ORIGINAL / AUTÊNTICO**.

---

## 6. VANTAGENS E LIMITAÇÕES DA SOLUÇÃO

A arquitetura integrada concebida apresenta um desempenho superior quando comparada com abordagens de força bruta convencionais, embora acarrete compromissos inerentes à sua natureza probabilística.

### 6.1. Vantagens Propostas
* **Alta Escalabilidade e Eficiência de CPU:** A inclusão do Filtro de Bloom mitiga o desperdício de recursos de processamento ao intercetar cópias integrais de forma imediata com custo computacional constante $O(k)$, protegendo os algoritmos mais pesados situados a jusante.
* **Otimização Crítica de Memória (RAM):** O MinHash elimina a necessidade de manter cópias integrais dos textos originais em memória para computar interseções. A retenção exclusiva das assinaturas numéricas compactas traduz-se num excelente *footprint* de infraestrutura.
* **Deteção Inteligente além da Literalidade:** A integração do classificador Naïve Bayes dota o sistema da capacidade de detetar indícios de plágio mesmo quando há substituição deliberada de termos por sinónimos (paráfrase estruturada), cenário onde as métricas puramente literais do MinHash tendem a falhar.

### 6.2. Limitações Identificadas
* **Inflexibilidade Estrutural do Filtro de Bloom:** Sendo uma estrutura estática baseada em vetores de bits e funções de *hash* não invertíveis, o Bloom Filter clássico não suporta operações de remoção de itens. Caso um documento precise de ser retirado da base legal, torna-se imperativo reinicializar e reconstruir o filtro na sua totalidade.
* **Assunção Simplista de Independência Termológica:** O Naïve Bayes assume, por definição teórica, que a ocorrência de cada palavra é inteiramente independente das restantes no texto. Esta simplificação destrói a coesão sintática e a ordem das palavras na frase, impossibilitando uma verdadeira análise de contexto semântico.
* **Sensibilidade à Parametrização de *Shingles*:** O tamanho adotado de $k=2$ (*word shingles*) revelou-se muito eficaz para textos curtos, mas pode induzir falsos positivos marginais em documentos extensos devido à repetição natural de expressões idiomáticas e conectores comuns da língua portuguesa. Aumentar o valor de $k$ blindaria o sistema contra este ruído, mas tornaria o MinHash excessivamente vulnerável a edições pontuais de pontuação ou inserções mínimas de caracteres.