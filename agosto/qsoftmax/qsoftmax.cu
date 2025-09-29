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

int main()
{
    int M, N;
    std::cin >> M >> N;
    int length = M * N;
    float *matriz, *matrizHost = new float[length];
    cudaMalloc(&matriz, length * sizeof(float));
    for (int i = 0; i < length; i++)
        std::cin >> matrizHost[i];
    cudaMemcpy(matriz, matrizHost, length * sizeof(float), cudaMemcpyHostToDevice);
    while (true)
    {
        int L, C1, C2;
        if (!(std::cin >> L >> C1 >> C2))
            break;

        int softmaxResultLength = C2 - C1 + 1;
        float *softmaxResult, *softmaxResultHost = new float[softmaxResultLength];
        cudaMalloc(&softmaxResult, softmaxResultLength * sizeof(float));

        int linha = L * N;
        for (int i = C1, j = 0; i <= C2; i++, j++)
            softmaxResultHost[j] = matrizHost[linha + i];
        cudaMemcpy(softmaxResult, softmaxResultHost, softmaxResultLength * sizeof(float), cudaMemcpyHostToDevice);

        int threads = softmaxResultLength > 32 ? 32 : softmaxResultLength;
        int blocks = (softmaxResultLength + threads - 1) / threads;
        softmax<<<blocks, threads, softmaxResultLength * sizeof(float)>>>(softmaxResult, softmaxResultLength);
        cudaDeviceSynchronize();
        cudaMemcpy(softmaxResultHost, softmaxResult, softmaxResultLength * sizeof(float), cudaMemcpyDeviceToHost);
        for (int j = C1; j <= C2; j++)
        {
            std::cout << std::fixed << std::setprecision(4) << softmaxResultHost[L * N + j];
            if (j < C2)
                std::cout << " ";
        }
        std::cout << std::endl;
        cudaFree(softmaxResult);
    }
    cudaFree(matriz);
    return 0;
}