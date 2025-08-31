#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void calculaCelulas(float *matrizA, float *matrizB, float *matrizC, int N)
{
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    float soma = 0.0f;
    for (int i = 0; i < N; i++)
        soma += matrizA[x * N + i] * matrizB[i * N + y];
    matrizC[x * N + y] = soma;
}

int main()
{
    int N;
    std::cin >> N;
    float *matrizA = new float[N * N];
    float *matrizB = new float[N * N];
    float *matrizC = new float[N * N];

    cudaMalloc(&matrizA, N * N * sizeof(float));
    cudaMalloc(&matrizB, N * N * sizeof(float));
    cudaMalloc(&matrizC, N * N * sizeof(float));
    
    dim3 threadsPerBlock(N, N);

    float valor;
    for (int i = 0; i < N * N; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&matrizA[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }
    for (int i = 0; i < N * N; i++)
    {
        std::cin >> valor;
        cudaMemcpy(&matrizB[i], &valor, sizeof(float), cudaMemcpyHostToDevice);
    }

    calculaCelulas<<<1, threadsPerBlock>>>(matrizA, matrizB, matrizC, N);
    for (int i = 0; i < N * N; i++)
    {
        cudaMemcpy(&valor, &matrizC[i], sizeof(float), cudaMemcpyDeviceToHost);
        std::cout << std::fixed << std::setprecision(2) << valor << " ";
        if ((i + 1) % N == 0)
            std::cout << std::endl;
    }
    return 0;
}