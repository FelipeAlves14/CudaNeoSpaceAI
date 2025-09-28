#include <cub/cub.cuh>
#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void softmax(float *produto, int N)
{
    int linha = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < N)
    {
        extern __shared__ float sdata[];

        float max = produto[linha * N];
        for (int j = 1; j < N; j++)
        {
            float val = produto[linha * N + j];
            if (val > max)
                max = val;
        }

        float soma = 0.0f;
        for (int j = 0; j < N; j++)
        {
            sdata[j] = expf(produto[linha * N + j] - max);
            soma += sdata[j];
        }

        for (int j = 0; j < N; j++)
        {
            produto[linha * N + j] = sdata[j] / soma;
        }
    }
}

__global__ void calculaProduto(float *Q, float *K, float *produto, int N, int M, bool transposta = false)
{
    int linha = blockIdx.y * blockDim.y + threadIdx.y;
    int coluna = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < N && coluna < M)
    {
        float soma = 0.0f;
        for (int i = 0; i < N; i++)
            soma += Q[linha * N + i] * K[transposta ? coluna * N + i : i * M + coluna];
        produto[linha * N + coluna] = transposta ? soma / sqrtf(N) : soma;
    }
}

int main()
{
    int M, N;
    std::cin >> M >> N;
    int lengthArray = M * N;
    float *Q, *QHost = new float[lengthArray], *K, *KHost = new float[lengthArray], *V, *VHost = new float[lengthArray], *produto, *produtoHost = new float[N * N];
    cudaMalloc(&Q, lengthArray * sizeof(float));
    cudaMalloc(&K, lengthArray * sizeof(float));
    cudaMalloc(&V, lengthArray * sizeof(float));
    cudaMalloc(&produto, N * N * sizeof(float));

    int threads = M > 32 ? 32 : M;
    int blocks = (M + threads - 1) / threads;
    dim3 threadsPerBlock(threads, threads);
    dim3 numBlocks(blocks, blocks);

    for (int i = 0; i < lengthArray; i++)
        std::cin >> QHost[i];
    cudaMemcpy(Q, QHost, lengthArray * sizeof(float), cudaMemcpyHostToDevice);

    for (int i = 0; i < lengthArray; i++)
        std::cin >> KHost[i];
    cudaMemcpy(K, KHost, lengthArray * sizeof(float), cudaMemcpyHostToDevice);

    for (int i = 0; i < lengthArray; i++)
        std::cin >> VHost[i];
    cudaMemcpy(V, VHost, lengthArray * sizeof(float), cudaMemcpyHostToDevice);

    calculaProduto<<<numBlocks, threadsPerBlock>>>(Q, K, produto, N, M, true);
    cudaDeviceSynchronize();
    softmax<<<blocks, threads, N * sizeof(float)>>>(produto, M);
    cudaDeviceSynchronize();
    cudaMemcpy(produtoHost, produto, N * N * sizeof(float), cudaMemcpyDeviceToHost);
    for (int i = 0; i < lengthArray; i++)
    {
        if (!((i + 1) % N == 0))
            std::cout << std::fixed << std::setprecision(4) << produtoHost[i] << " ";
        else
            std::cout << std::endl;
    }
}