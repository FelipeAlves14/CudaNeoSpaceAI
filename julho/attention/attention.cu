#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void softmax(float *softmax, int M)
{
    int linha = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < M)
    {
        extern __shared__ float sdata[];

        float max = softmax[linha * M];
        for (int j = 1; j < M; j++)
        {
            float val = softmax[linha * M + j];
            if (val > max)
                max = val;
        }

        float soma = 0.0f;
        for (int j = 0; j < M; j++)
        {
            int index = linha * M + j;
            sdata[index] = expf(softmax[index] - max);
            soma += sdata[index];
        }

        for (int j = 0; j < M; j++)
        {
            int index = linha * M + j;
            softmax[index] = sdata[index] / soma;
        }
    }
}

__global__ void calculaProduto(float *Q, float *K, float *resultado, int M, int N, bool transposta = false)
{
    int linha = blockIdx.y * blockDim.y + threadIdx.y;
    int coluna = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < M && coluna < N)
    {
        float soma = 0.0f;
        if (transposta)
        {
            for (int i = 0; i < N; i++)
                soma += Q[linha * N + i] * K[coluna * N + i];
            resultado[linha * M + coluna] = soma / sqrtf(N);
        }
        else
        {
            for (int i = 0; i < N; i++)
                soma += Q[linha * M + i] * K[i * N + coluna];
            resultado[linha * N + coluna] = soma;
        }
    }
}

int main()
{
    int M, N;
    std::cin >> M >> N;
    int arrayLength = M * N;
    int softmaxResultLength = M * M;
    float *Q, *QHost = new float[arrayLength],
              *K, *KHost = new float[arrayLength],
              *V, *VHost = new float[arrayLength],
              *softmaxResult,
              *resultado, *resultadoHost = new float[arrayLength];
    cudaMalloc(&Q, arrayLength * sizeof(float));
    cudaMalloc(&K, arrayLength * sizeof(float));
    cudaMalloc(&V, arrayLength * sizeof(float));
    cudaMalloc(&softmaxResult, softmaxResultLength * sizeof(float));
    cudaMalloc(&resultado, arrayLength * sizeof(float));

    int threads = M > 32 ? 32 : M;
    int blocks = (M + threads - 1) / threads;
    dim3 threadsPerBlock(threads, threads);
    dim3 numBlocks(blocks, blocks);

    for (int i = 0; i < arrayLength; i++)
        std::cin >> QHost[i];
    cudaMemcpy(Q, QHost, arrayLength * sizeof(float), cudaMemcpyHostToDevice);

    for (int i = 0; i < arrayLength; i++)
        std::cin >> KHost[i];
    cudaMemcpy(K, KHost, arrayLength * sizeof(float), cudaMemcpyHostToDevice);

    for (int i = 0; i < arrayLength; i++)
        std::cin >> VHost[i];
    cudaMemcpy(V, VHost, arrayLength * sizeof(float), cudaMemcpyHostToDevice);

    calculaProduto<<<numBlocks, threadsPerBlock>>>(Q, K, softmaxResult, M, N, true);
    cudaDeviceSynchronize();

    softmax<<<blocks, threads, M * sizeof(float)>>>(softmaxResult, M);
    cudaDeviceSynchronize();

    threads = N > 32 ? 32 : N;
    threadsPerBlock = dim3(threads, threads);
    blocks = (N + threads - 1) / threads;
    numBlocks = dim3(blocks, blocks);
    calculaProduto<<<numBlocks, threadsPerBlock>>>(softmaxResult, V, resultado, M, N);
    cudaDeviceSynchronize();

    cudaMemcpy(resultadoHost, resultado, arrayLength * sizeof(float), cudaMemcpyDeviceToHost);
    for (int i = 0; i < arrayLength; i++)
    {
        std::cout << std::fixed << std::setprecision(4) << resultadoHost[i] << " ";
        if ((i + 1) % N == 0)
            std::cout << std::endl;
    }
    cudaFree(Q);
    cudaFree(K);
    cudaFree(V);
    cudaFree(softmaxResult);
    cudaFree(resultado);
    return 0;
}