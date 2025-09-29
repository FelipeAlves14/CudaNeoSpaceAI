#include <cub/cub.cuh>
#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdio.h>

__global__ void softmax(float *softmax, float *softmaxTransform, int M, float maxValue)
{
    int linha = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < M)
        softmaxTransform[linha] = expf(softmax[linha] - maxValue);
}

__global__ void resultSoftmax(float *softmaxTransform, float *result, int M, float sumValue)
{
    int linha = blockIdx.x * blockDim.x + threadIdx.x;
    if (linha < M)
        result[linha] = softmaxTransform[linha] / sumValue;
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
        float *softmaxResult, *softmaxResultHost = new float[softmaxResultLength],
                              *maxSoftmaxValue,
                              *softmaxTransform, *softmaxTransformHost = new float[softmaxResultLength],
                              *sumSoftmaxValue;
        float maxSoftmaxValueHost = 0.0f, sumSoftmaxValueHost = 0.0f;
        cudaMalloc(&softmaxResult, softmaxResultLength * sizeof(float));
        cudaMalloc(&softmaxTransform, softmaxResultLength * sizeof(float));
        cudaMalloc(&maxSoftmaxValue, sizeof(float));
        cudaMalloc(&sumSoftmaxValue, sizeof(float));

        int linha = L * N;
        for (int i = C1, j = 0; i <= C2; i++, j++)
            softmaxResultHost[j] = matrizHost[linha + i];
        cudaMemcpy(softmaxResult, softmaxResultHost, softmaxResultLength * sizeof(float), cudaMemcpyHostToDevice);

        void *tempStorage = nullptr;
        size_t tempStorageBytes = 0;
        cub::DeviceReduce::Max(tempStorage, tempStorageBytes, softmaxResult, maxSoftmaxValue, softmaxResultLength);
        cudaMalloc(&tempStorage, tempStorageBytes);
        cub::DeviceReduce::Max(tempStorage, tempStorageBytes, softmaxResult, maxSoftmaxValue, softmaxResultLength);
        cudaFree(tempStorage);
        cudaMemcpy(&maxSoftmaxValueHost, maxSoftmaxValue, sizeof(float), cudaMemcpyDeviceToHost);

        int threads = softmaxResultLength > 32 ? 32 : softmaxResultLength;
        int blocks = (softmaxResultLength + threads - 1) / threads;
        softmax<<<blocks, threads, softmaxResultLength * sizeof(float)>>>(softmaxResult, softmaxTransform, softmaxResultLength, maxSoftmaxValueHost);
        cudaDeviceSynchronize();

        void *tempStorage2 = nullptr;
        size_t tempStorageBytes2 = 0;
        cub::DeviceReduce::Sum(tempStorage2, tempStorageBytes2, softmaxTransform, sumSoftmaxValue, softmaxResultLength);
        cudaMalloc(&tempStorage2, tempStorageBytes2);
        cub::DeviceReduce::Sum(tempStorage2, tempStorageBytes2, softmaxTransform, sumSoftmaxValue, softmaxResultLength);
        cudaFree(tempStorage2);
        cudaMemcpy(&sumSoftmaxValueHost, sumSoftmaxValue, sizeof(float), cudaMemcpyDeviceToHost);

        resultSoftmax<<<blocks, threads, softmaxResultLength * sizeof(float)>>>(softmaxTransform, softmaxResult, softmaxResultLength, sumSoftmaxValueHost);
        cudaDeviceSynchronize();

        cudaMemcpy(softmaxResultHost, softmaxResult, softmaxResultLength * sizeof(float), cudaMemcpyDeviceToHost);
        for (int j = 0; j < softmaxResultLength; j++)
        {
            std::cout << std::fixed << std::setprecision(4) << softmaxResultHost[j];
            if (j < C2)
                std::cout << " ";
        }
        std::cout << std::endl;
        cudaFree(softmaxResult);
    }
    cudaFree(matriz);
    cudaFree(softmaxResult);
    cudaFree(maxSoftmaxValue);
    cudaFree(softmaxTransform);
    cudaFree(sumSoftmaxValue);
    return 0;
}