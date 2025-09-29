# Desafio C - Attention(Q, K, V)

## Descrição

Neste desafio deverá ser feito o cálculo da atenção, conforme o artigo original da Arquitetura Transformer “Attention is
All You Need” publicado em [https://arxiv.org/pdf/1706.03762](https://arxiv.org/pdf/1706.03762). Use sempre precisão com FP32.

## Entrada

- A primeira linha da entrada terá dois números M e N (2 <= M, N <= 4096), respectivos à ordem das matrizes Q, K e V.
- Após, haverá 3*M linhas, cada uma com N números em FP32 de valor X (0.00 <= X <= 1.00).
- As primeiras M linhas correspondem à matriz Q, as próximas M linhas à matriz K e as próximas M linhas à matriz V.
- Considere dk=N.

## Saída

A saída mostrará a matriz referente a Attention(Q, K, V), com 4 casas decimais. Devido às possíveis diferenças de
precisão em ambientes, serão válidas soluções com variação de até 0.03 (3 centésimos), em um número.
O código precisará gerar a saída exatamente conforme o exemplo abaixo. Sem mensagens adicionais, nem espaço ao
final de qualquer linha da matriz.

### Exemplo de entrada

```txt
3 4
0.23 0.46 0.28 0.35
0.50 0.76 0.72 0.49
0.19 0.66 0.22 0.28
0.45 0.75 0.55 0.23
0.90 0.86 0.46 0.10
0.93 0.70 0.61 0.95
0.23 0.69 0.95 0.23
0.08 0.64 0.52 0.67
0.76 0.96 0.59 0.09
```

### Exemplo de Saída

```txt
0.3773 0.7736 0.6787 0.3200
0.3899 0.7799 0.6723 0.3150
0.3706 0.7703 0.6795 0.3246
```
