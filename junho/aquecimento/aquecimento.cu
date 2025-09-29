#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void calculaCelulas(float *A, float *B, float *produto, int N)
{
    int linha = blockIdx.y * blockDim.y + threadIdx.y;
    int coluna = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < N && coluna < N)
    {
        float soma = 0.0f;
        for (int i = 0; i < N; i++)
            soma += A[linha * N + i] * B[i * N + coluna];
        produto[linha * N + coluna] = soma;
    }
}

int main()
{
    int N;
    std::cin >> N;
    int lengthArray = N * N;
    float *A, *AHost = new float[lengthArray],
              *B, *BHost = new float[lengthArray],
              *produto, *produtoHost = new float[lengthArray];
    cudaMalloc(&A, lengthArray * sizeof(float));
    cudaMalloc(&B, lengthArray * sizeof(float));
    cudaMalloc(&produto, lengthArray * sizeof(float));

    int threads = N > 32 ? 32 : N;
    int blocks = (N + threads - 1) / threads;
    dim3 threadsPerBlock(threads, threads);
    dim3 numBlocks(blocks, blocks);

    for (int i = 0; i < lengthArray; i++)
        std::cin >> AHost[i];
    cudaMemcpy(A, AHost, lengthArray * sizeof(float), cudaMemcpyHostToDevice);

    for (int i = 0; i < lengthArray; i++)
        std::cin >> BHost[i];
    cudaMemcpy(B, BHost, lengthArray * sizeof(float), cudaMemcpyHostToDevice);

    calculaCelulas<<<numBlocks, threadsPerBlock>>>(A, B, produto, N);
    cudaDeviceSynchronize();
    cudaMemcpy(produtoHost, produto, lengthArray * sizeof(float), cudaMemcpyDeviceToHost);
    for (int i = 0; i < lengthArray; i++)
    {
        std::cout << std::fixed << std::setprecision(2) << produtoHost[i] << " ";
        if ((i + 1) % N == 0)
            std::cout << std::endl;
    }
    cudaFree(A);
    cudaFree(B);
    cudaFree(produto);
    return 0;
}