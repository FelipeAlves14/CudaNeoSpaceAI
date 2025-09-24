#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void calculaProdutoEscalar(float *Q, float *K, float *produtoEscalar, int N, int M)
{
    int linha = blockIdx.y * blockDim.y + threadIdx.y;
    int coluna = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < N && coluna < M)
    {
        float soma = 0.0f;
        for (int i = 0; i < N; i++)
            soma += Q[linha * N + i] * K[coluna * N + i];
        produtoEscalar[linha * N + coluna] = soma;
    }
}

int main()
{
    int M, N;
    std::cin >> M >> N;
    float *Q, *K, *V, *produto;
    cudaMalloc(&Q, M * N * sizeof(float));
    cudaMalloc(&K, M * N * sizeof(float));
    cudaMalloc(&V, M * N * sizeof(float));
    cudaMalloc(&produto, N * N * sizeof(float));

    int threads = M > 32 ? 32 : M;
    int blocks = (M + threads - 1) / threads;
    dim3 threadsPerBlock(threads, threads);
    dim3 numBlocks(blocks, blocks);

    int lengthArray = M * N;
    float valor;

    for (int i = 0; i < lengthArray; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&Q[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }

    for (int i = 0; i < lengthArray; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&K[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }

    for (int i = 0; i < lengthArray; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&V[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }
    calculaProdutoEscalar<<<numBlocks, threadsPerBlock>>>(Q, K, produto, N, M);
    for (int i = 0; i < lengthArray; i++)
    {
        if (!((i + 1) % N == 0))
        {
            cudaMemcpy(&valor, &produto[i], sizeof(float), cudaMemcpyDeviceToHost);
            std::cout << std::fixed << std::setprecision(4) << valor << " ";
        }
        else
            std::cout << std::endl;
    }
}