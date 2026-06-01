# Sistema de Deteção de Plágio - MPEI
Este projeto implementa um sistema de deteção de plágio usando três algoritmos probabilísticos: Bloom Filter, Naïve Bayes e MinHash. O nosso objetivo principal foi aplicar de forma prática os conhecimentos de estruturas de dados probabilísticas, classificadores bayesianos e estimadores de similaridade num cenário real de auditoria de texto.

## Membros do Grupo
| Nome | Nº Mec |
|------|--------|
| Cristiane Moreno |
| Francisco |124677 | 


## O que o sistema faz
O sistema analisa um documento em três camadas:
- **Bloom Filter** – verifica se é cópia exata.
- **Naïve Bayes** – analisa o estilo do texto.
- **MinHash** – calcula a similaridade com documentos originais.


## Funcionamento dos Módulos
### Bloom Filter 
O Bloom Filter verifica se um documento já existe na base de dados:
- Se diz que **não** existe cópia.
- Se diz que **existe**  cópia (pode haver falso positivo).

**Parâmetros utilizados:** Tamanho do vetor (m) = 2000, número de funções de hash (k) = 4.


### Naïve Bayes 
O Naïve Bayes analisa a frequência das palavras no texto:
- Treinado com 6 originais e 6 plágios.
- Usa suavização de Laplace (soma 1) para evitar probabilidades zero.
- Usa logaritmos para evitar underflow numérico.


### MinHash 
O MinHash estima a similaridade entre documentos de forma rápida:
- Divide o texto em shingles de 2 palavras.
- Reduz cada conjunto a uma assinatura numérica.
- A similaridade é a taxa de colisão entre assinaturas.

**Parâmetros utilizados:** shingles k=2, 200 funções de hash (testado com 50, 100, 200 e 500 funções de hash).


## Pré-processamento de Dados
Antes da análise, o texto é normalizado:
- Converter para minúsculas
- Remover pontuação e caracteres especiais
- Remover espaços extras


## Como Executar
1. Abra o **MATLAB**.
2. Execute o script `setup.m` na raiz do projeto para adicionar as pastas ao path.
3. Execute o programa de demonstração principal digitando o comando:
   ```matlab
   main_demo
4. tester isolados:
   teste_bloom_filter 
   teste_naive_bayes       
   test_minhash_simples   
   test_minhash_all_dataset 
   grafico