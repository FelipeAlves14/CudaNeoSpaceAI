# Desafio E - TopK

## Descrição

Neste desafio será feita a seleção dos TopK maiores valores nas linhas de uma matriz e, estes valores, serão mostrados
em ordem decrescente. A solução deverá ser completa em CUDA e rodar em GPU, exceto a entrada e saída de dados
(printf, cin, scanf e cout). A solução precisa ter desempenho para processar os casos de teste em até 300 segundos (5
minutos), caso contrário, receberá TLE (Time Limit Exceeded).

## Entrada

- A primeira linha da entrada terá três números inteiros K, M e N (5 <= K <= 15; 2 <= M, N <= 4096), sendo M e N potência de 2.
- O valor K é o percentual da quantidade de números a serem selecionados na linha da matriz, com arredondamento para cima.
- Os valores M e N são respectivos à quantidade de linhas e colunas da matriz.
- Após, haverá M linhas, cada uma com N números de valor X (0.00 <= X <= 1.00), com 3 casas decimais.

## Saída

A saída mostrará os TopK maiores números, em ordem decrescente, de forma exata (sem aproximação). O código
precisará gerar a saída conforme o exemplo abaixo, sem mensagens adicionais, nem espaço ao final de qualquer linha.
Exemplo do cálculo da quantidade dos TopK números:
K=10, M=2, N=32, seleciona os 4 maiores números (3.2 arredondado para cima).
K=15, M=4, N=16, seleciona os 3 maiores números (2.4 arredondado para cima).

### Exemplo de entrada

```txt
15 4 16
0.739 0.172 0.748 0.676 0.022 0.255 0.827 0.507 0.167 0.129 0.068 0.954 0.949 0.386 0.785 0.236
0.841 0.879 0.735 0.028 0.069 0.485 0.160 0.420 0.409 0.865 0.569 0.907 0.537 0.028 0.315 0.943
0.325 0.313 0.520 0.483 0.779 0.700 0.013 0.135 0.264 0.685 0.459 0.318 0.502 0.412 0.937 0.630
0.188 0.518 0.555 0.675 0.807 0.065 0.409 0.206 0.784 0.819 0.815 0.211 0.350 0.445 0.256 0.106
```

### Exemplo de saída

```txt
0.954 0.949 0.827
0.943 0.907 0.879
0.937 0.779 0.700
0.819 0.815 0.807
```
