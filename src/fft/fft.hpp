#pragma once

#include <complex>
#include <vector>

namespace FFT
{
    static constexpr float PI = 3.14159265358979323846f;

    void forward(std::vector<std::complex<float>> &buffer);
    void reverse(std::vector<std::complex<float>> &buffer);
    void forward(std::vector<std::complex<float>> &buffer, const std::vector<std::complex<float>> &twiddles);
    void reverse(std::vector<std::complex<float>> &buffer, const std::vector<std::complex<float>> &twiddles);

    std::vector<std::complex<float>> compute_twiddles(int n);
};