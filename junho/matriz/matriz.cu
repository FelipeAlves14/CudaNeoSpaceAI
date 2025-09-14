#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void calculaCelulas(float *matrizA, float *matrizB, float *matrizC, int N)
{
    int linha = blockIdx.y * blockDim.y + threadIdx.y;
    int coluna = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < N && coluna < N)
    {
        float soma = 0.0f;
        for (int i = 0; i < N; i++)
            soma += matrizA[linha * N + i] * matrizB[i * N + coluna];
        matrizC[linha * N + coluna] = soma;
    }
}

int main()
{
    int N;
    std::cin >> N;
    int lengthArray = N * N;
    float *matrizA, *matrizB, *matrizC;
    cudaMalloc(&matrizA, lengthArray * sizeof(float));
    cudaMalloc(&matrizB, lengthArray * sizeof(float));
    cudaMalloc(&matrizC, lengthArray * sizeof(float));
    int threads = N > 32 ? 32 : N;
    int blocks = (N + threads - 1) / threads;
    dim3 threadsPerBlock(threads, threads);
    dim3 numBlocks(blocks, blocks);

    float valor;
    for (int i = 0; i < lengthArray; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&matrizA[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }
    for (int i = 0; i < lengthArray; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&matrizB[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }

    calculaCelulas<<<numBlocks, threadsPerBlock>>>(matrizA, matrizB, matrizC, N);
    for (int i = 0; i < lengthArray; i++)
    {
        cudaMemcpy(&valor, &matrizC[i], sizeof(float), cudaMemcpyDeviceToHost);
        std::cout << std::fixed << std::setprecision(2) << valor << " ";
        if ((i + 1) % N == 0)
            std::cout << std::endl;
    }
    return 0;
}