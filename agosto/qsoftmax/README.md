# Desafio D - Queries de Softmax

## Descrição

Neste desafio será feito o cálculo da Softmax nas linhas de uma matriz, para uma sequência de perguntas ( queries). A
solução deverá ter desempenho para processar os casos de teste em até 300 segundos (5 minutos), caso contrário,
receberá TLE (Time Limit Exceeded).

## Entrada

- A primeira linha da entrada terá dois números M e N (2 <= M, N <= 4096), respectivos à quantidade de linhas e colunas da matriz.
- Após, haverá M linhas, cada uma com N números em FP32 de valor X (0.00 <= X <= 1.00).
- Por fim, haverá uma quantidade indeterminada de linhas com perguntas (queries), formadas por 3 inteiros L, C1, C2 (0 <= L < M; 0 <= C1, C2 < N), que representam respectivamente a linha, a coluna de início e a coluna final para calcular a Softmax.

## Saída

A saída mostrará o cálculo da Softmax para cada pergunta da entrada, com 4 casas decimais. Devido às possíveis
diferenças de precisão em ambientes, serão válidas soluções com variação de até 0.02 (2 centésimos), em um número.
O código precisará gerar a saída exatamente conforme o exemplo abaixo, sem mensagens adicionais, nem espaço ao
final de qualquer linha.

### Exemplo de entrada

```txt
4 8
0.34 0.76 0.32 0.02 0.81 0.65 0.59 0.45
0.18 0.63 0.18 0.73 0.10 0.57 0.88 0.68
0.60 0.20 0.11 0.26 0.70 0.54 0.86 0.93
0.35 0.89 0.66 0.02 0.18 0.56 0.79 0.12
0 0 7
2 4 7
3 1 5
2 0 5
0 2 3
```

### Exemplo de Saída

```txt
0.1043 0.1587 0.1022 0.0757 0.1668 0.1421 0.1339 0.1164
0.2334 0.1989 0.2739 0.2938
0.2921 0.2320 0.1224 0.1436 0.2100
0.1983 0.1330 0.1215 0.1412 0.2192 0.1868
0.5744 0.4256
```
