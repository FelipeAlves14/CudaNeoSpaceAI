# Desafio A - Aquecimento com Matriz

## Descrição

Este primeiro desafio é um aquecimento, para testar o processo desde a submissão de códigos, até a avaliação e visualização do resultado. Use sempre precisão com FP32.

## Entrada

- A primeira linha da entrada será um número N (2 <= N <= 128), que representa a ordem de 2 matrizes a serem multiplicadas.
- Após, haverá N linhas, cada uma com N números em FP32 de valor V (0.00 <= V <= 10.00), correspondentes à matriz A.
- Em seguida, haverá N linhas, cada uma com N números em FP32 de valor V (0.00 <= V <= 10.00), correspondentes à matriz B.

### Saída

A saída mostrará o resultado da multiplicação das matrizes A x B, com 2 casas decimais. Devido às possíveis diferenças de precisão, em diferentes arquiteturas, serão válidas soluções com variação de até 0.02, em cada número.

### Exemplo de Entrada

```txt
4  
0.49 3.17 1.09 2.81  
5.43 8.78 5.31 4.93  
1.37 0.35 3.30 0.53  
9.81 1.43 9.77 1.47  
1.50 1.00 4.05 1.93  
6.63 5.51 9.83 1.68  
3.48 5.22 2.89 9.60  
1.09 0.34 1.52 6.98
```

### Exemplo de Saída

```txt
28.61 24.60 40.57 36.35  
90.21 83.20 131.14 110.62  
16.44 20.70 19.33 38.61  
59.80 69.19 84.26 125.39  
```
