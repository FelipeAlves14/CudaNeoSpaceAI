# Desafio B - Matriz Aquecida

## Descrição

Este primeiro desafio é um aquecimento, para testar o processo desde a submissão de códigos, até a avaliação e visualização do resultado. Use sempre precisão com FP32.

## Entrada

- A primeira linha da entrada será um número N (2 <= N <= 4096), que representa a ordem de 2 matrizes a serem multiplicadas.
- Após, haverá N linhas, cada uma com N números em FP32 de valor V (0.00 <= V <= 1.00), correspondentes à matriz A.
- Em seguida, haverá N linhas, cada uma com N números em FP32 de valor V (0.00 <= V <= 1.00), correspondentes à matriz B.

## Saída

A saída mostrará o resultado da multiplicação das matrizes A x B, com 2 casas decimais. Devido às possíveis diferenças de precisão, em diferentes arquiteturas, serão válidas soluções com variação de até 0.02, em cada número.

### Exemplo de Entrada

```txt
4
0.20 0.59 0.40 0.45
0.58 0.44 0.41 0.55
0.08 0.08 0.63 0.86
0.93 0.29 0.81 0.34
0.70 0.84 0.13 0.61
0.38 0.93 0.88 0.23
0.32 0.15 0.71 0.57
0.39 0.61 0.27 0.24
```

### Exemplo de Saída

```txt
0.67 1.05 0.95 0.59
0.92 1.29 0.90 0.82
0.62 0.76 0.76 0.63
1.15 1.38 1.04 1.18
```
