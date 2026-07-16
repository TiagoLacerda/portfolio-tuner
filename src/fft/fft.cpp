#include "fft.hpp"

#include <cmath>

static bool is_power_of_two(int n)
{
    return n > 0 && (n & (n - 1)) == 0;
}

static int reverse_bits(int value, int bits)
{
    int result = 0;

    for (int i = 0; i < bits; ++i)
    {
        result = (result << 1) | (value & 1);
        value >>= 1;
    }

    return result;
}

void FFT::forward(std::vector<std::complex<float>> &buffer)
{
    int n = static_cast<int>(buffer.size());

    if (n < 2 || !is_power_of_two(n))
    {
        return;
    }

    auto twiddles = compute_twiddles(n);
    forward(buffer, twiddles);
}

void FFT::reverse(std::vector<std::complex<float>> &buffer)
{
    int n = static_cast<int>(buffer.size());

    if (n < 2 || !is_power_of_two(n))
    {
        return;
    }

    auto twiddles = compute_twiddles(n);
    reverse(buffer, twiddles);
}

void FFT::forward(std::vector<std::complex<float>> &buffer, const std::vector<std::complex<float>> &twiddles)
{
    int n = static_cast<int>(buffer.size());
    int bits = 0;

    while ((1 << bits) < n)
    {
        ++bits;
    }

    // Bit-reversal permutation
    for (int i = 0; i < n; ++i)
    {
        int j = reverse_bits(i, bits);
        if (i < j)
        {
            std::swap(buffer[i], buffer[j]);
        }
    }

    for (int size = 2; size <= n; size <<= 1)
    {
        int halfSize = size >> 1;
        int step = n / size;

        for (int block = 0; block < n; block += size)
        {
            for (int j = 0; j < halfSize; ++j)
            {
                int twiddleIndex = j * step;
                std::complex<float> t = twiddles[twiddleIndex] * buffer[block + j + halfSize];

                std::complex<float> u = buffer[block + j];
                buffer[block + j] = u + t;
                buffer[block + j + halfSize] = u - t;
            }
        }
    }
}

void FFT::reverse(std::vector<std::complex<float>> &buffer, const std::vector<std::complex<float>> &twiddles)
{
    int n = static_cast<int>(buffer.size());

    for (int i = 0; i < n; ++i)
    {
        buffer[i] = std::conj(buffer[i]);
    }

    forward(buffer, twiddles);

    for (int i = 0; i < n; ++i)
    {
        buffer[i] = std::conj(buffer[i]);
    }

    float scale = 1.0f / static_cast<float>(n);

    for (auto &value : buffer)
    {
        value *= scale;
    }
}

std::vector<std::complex<float>> FFT::compute_twiddles(int n)
{
    std::vector<std::complex<float>> result(n >> 1);

    for (int k = 0; k < static_cast<int>(result.size()); ++k)
    {
        float angle = -2.0f * PI * static_cast<float>(k) / static_cast<float>(n);
        result[k] = std::complex<float>(std::cos(angle), std::sin(angle));
    }

    return result;
}
