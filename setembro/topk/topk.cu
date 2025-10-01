#include <bits/stdc++.h>
#include <cub/cub.cuh>
#include <cuda_runtime.h>

__global__ void topk(float *linha_sorted, float *resultado, int N, int topK)
{
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < topK)
        resultado[tid] = linha_sorted[N - topK + tid];
}

int main()
{
    int K, M, N;
    std::cin >> K >> M >> N;

    int length = M * N;
    int topK = std::ceil(N * (K / 100.0));
    int lengthOut = M * topK;

    std::valarray<float> matrizHost(length);
    for (int i = 0; i < length; i++)
        std::cin >> matrizHost[i];

    std::vector<float> outHost(lengthOut);

    for (int row = 0; row < M; row++)
    {
        std::valarray<float> linhaHost = matrizHost[std::slice(row * N, N, 1)];

        float *linha_in, *linha_sorted;
        cudaMalloc(&linha_in, N * sizeof(float));
        cudaMalloc(&linha_sorted, N * sizeof(float));
        cudaMemcpy(linha_in, &linhaHost[0], N * sizeof(float), cudaMemcpyHostToDevice);

        void *d_temp_storage = nullptr;
        size_t temp_storage_bytes = 0;
        cub::DeviceRadixSort::SortKeys(d_temp_storage, temp_storage_bytes,
                                       linha_in, linha_sorted, N);
        cudaMalloc(&d_temp_storage, temp_storage_bytes);
        cub::DeviceRadixSort::SortKeys(d_temp_storage, temp_storage_bytes,
                                       linha_in, linha_sorted, N);

        float *linha_out;
        cudaMalloc(&linha_out, topK * sizeof(float));

        int threads = std::min(32, topK);
        int blocks = (topK + threads - 1) / threads;
        topk<<<blocks, threads>>>(linha_sorted, linha_out, N, topK);

        cudaMemcpy(&outHost[row * topK], linha_out,
                   topK * sizeof(float), cudaMemcpyDeviceToHost);

        cudaFree(linha_in);
        cudaFree(linha_sorted);
        cudaFree(d_temp_storage);
        cudaFree(linha_out);
    }

    for (int row = 0; row < M; row++)
    {
        for (int j = topK - 1; j >= 0; j--)
            std::cout << std::fixed << std::setprecision(3) << outHost[row * topK + j] << " ";
        std::cout << std::endl;
    }

    return 0;
}
