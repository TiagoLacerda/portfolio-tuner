#include "yin.hpp"

#include <cmath>
#include <limits>

static int next_power_of_two(int value)
{
    int result = 1;

    while (result < value)
    {
        result <<= 1;
    }

    return result;
}

YIN::YIN(int minFrequency, int maxFrequency, int sampleRate)
{
    this->sampleRate = sampleRate;
    this->minLag = sampleRate / maxFrequency;
    this->maxLag = sampleRate / minFrequency;

    this->frameSamples = next_power_of_two(maxLag * 2);
    this->hopSamples = frameSamples / 2;
    this->fftSamples = next_power_of_two(frameSamples * 2);

    this->bufferSamples = frameSamples + maxLag;
    this->bufferPointer = 0;
    this->samplesSinceLastFrame = 0;

    this->window = compute_hanning(frameSamples);
    this->buffer = std::vector<float>(bufferSamples);
    this->fftBuffer = std::vector<std::complex<float>>(fftSamples);
}

float YIN::processBlock(float *samples, int length)
{
    auto pitch = -1.0f;

    for (int i = 0; i < length; ++i)
    {
        buffer[bufferPointer] = samples[i];
        bufferPointer = (bufferPointer + 1) % bufferSamples;
        ++samplesSinceLastFrame;

        if (samplesSinceLastFrame >= frameSamples)
        {
            pitch = estimate();
            samplesSinceLastFrame -= hopSamples;
        }
    }

    return pitch;
}

float YIN::ACF(int lag)
{
    float result = 0.0f;
    int frameStart = (bufferPointer - frameSamples + bufferSamples) % bufferSamples;

    for (int k = 0; k < frameSamples; ++k)
    {
        int idx1 = (frameStart + k) % bufferSamples;
        int idx2 = (idx1 + lag) % bufferSamples;
        float weight = window[k] * window[k];
        result += buffer[idx1] * buffer[idx2] * weight;
    }

    return result;
}

float YIN::DF(int lag)
{
    float result = 0.0f;

    int frameStart = (bufferPointer - frameSamples + bufferSamples) % bufferSamples;

    for (int k = 0; k < frameSamples; ++k)
    {
        int idx1 = (frameStart + k) % bufferSamples;
        int idx2 = (idx1 + lag) % bufferSamples;

        float difference = (buffer[idx1] - buffer[idx2]) * window[k];

        result += difference * difference;
    }

    return result;
}

std::vector<float> YIN::DFARR()
{
    int frameStart = (bufferPointer - frameSamples + bufferSamples) % bufferSamples;

    for (int i = 0; i < frameSamples; ++i)
    {
        int idx = (frameStart + i) % bufferSamples;
        fftBuffer[i] = std::complex<float>(buffer[idx] * window[i], 0.0f);
    }

    for (int i = frameSamples; i < fftSamples; ++i)
    {
        fftBuffer[i] = std::complex<float>(0.0f, 0.0f);
    }

    FFT::forward(fftBuffer);

    for (int i = 0; i < fftSamples; ++i)
    {
        fftBuffer[i] *= std::conj(fftBuffer[i]);
    }

    FFT::reverse(fftBuffer);

    std::vector<float> result(maxLag);

    float acf0 = fftBuffer[0].real();

    for (int lag = 0; lag < maxLag; ++lag)
    {
        result[lag] = 2.0f * (acf0 - fftBuffer[lag].real());
    }

    return result;
}

std::vector<float> YIN::CMNDF(const std::vector<float> &df)
{
    std::vector<float> result(maxLag);

    result[0] = 1.0f;

    float sum = 0.0f;

    for (int lag = 1; lag < maxLag; ++lag)
    {
        sum += df[lag];

        result[lag] = df[lag] * lag / (sum == 0.0f ? std::numeric_limits<float>::min() : sum);
    }

    return result;
}

float YIN::energy()
{

    float result = 0.0f;

    int frameStart = (bufferPointer - frameSamples + bufferSamples) % bufferSamples;

    for (int k = 0; k < frameSamples; ++k)
    {
        int idx = (frameStart + k) % bufferSamples;

        float sample = buffer[idx] * window[k];

        result += sample * sample;
    }

    return result / frameSamples;
}

float YIN::estimate()
{
    if (energy() < 1e-4)
    {
        return -1.0f;
    }

    float threshold = 1e-1f;

    auto df = DFARR();
    auto cmndf = CMNDF(df);

    int estimated = 0;

    for (int lag = minLag; lag < maxLag; ++lag)
    {
        // First minimum below threshold

        if (cmndf[lag] < threshold)
        {
            while (lag + 1 < maxLag && cmndf[lag + 1] < cmndf[lag])
            {
                ++lag;
            }

            estimated = lag;
            break;
        }
    }

    if (estimated < 1)
    {
        // Return global minimum

        int bestLag = 1;
        float bestValue = cmndf[bestLag];

        for (int lag = 2; lag < maxLag; ++lag)
        {
            if (cmndf[lag] < bestValue)
            {
                bestLag = lag;
                bestValue = cmndf[bestLag];
            }
        }

        estimated = bestLag;
    }

    float estimateFloat = static_cast<float>(estimated);

    if (estimated > 0 && estimated + 1 < maxLag)
    {
        // Parabollic interpolation

        float y0 = cmndf[estimated - 1];
        float y1 = cmndf[estimated];
        float y2 = cmndf[estimated + 1];

        float denominator = 2.0f * (y0 - 2.0f * y1 + y2);

        if (std::abs(denominator) > 1e-6f)
        {
            estimateFloat += (y0 - y2) / denominator;
        }
    }

    return sampleRate / estimateFloat;
}

std::vector<float> YIN::compute_hanning(int n)
{
    std::vector<float> result(n);

    if (n < 2)
    {
        if (n == 1)
        {
            result[0] = 1.0f;
        }

        return result;
    }

    const float scale = 2.0f * FFT::PI / static_cast<float>(n - 1);

    for (int i = 0; i < n; ++i)
    {
        result[i] = 0.5f - 0.5f * std::cos(scale * static_cast<float>(i));
    }

    return result;
}