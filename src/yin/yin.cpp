#include "yin.hpp"

#include <algorithm>
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
    this->hopSamples = frameSamples / 4;
    // No wrap-around: correlation only reads lags < maxLag of a signal zero beyond frameSamples - maxLag
    this->fftSamples = frameSamples;

    this->bufferSamples = frameSamples + maxLag;
    this->bufferPointer = 0;
    this->samplesSinceLastFrame = 0;

    this->buffer = std::vector<float>(bufferSamples);
    this->fftBuffer = std::vector<std::complex<float>>(fftSamples);
    this->twiddles = FFT::compute_twiddles(fftSamples);

    this->cumulativeEnergy = std::vector<double>(frameSamples + 1);
    this->differences = std::vector<float>(maxLag);
    this->normalizedDifferences = std::vector<float>(maxLag);
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

const std::vector<float> &YIN::DFARR()
{
    int frameStart = (bufferPointer - frameSamples + bufferSamples) % bufferSamples;

    // d(τ) = Σx²[0, W) + Σx²[τ, τ+W) - 2·Σx[j]·x[j+τ], with integration window W
    int integrationLength = frameSamples - maxLag;

    // cumulativeEnergy[i] = Σx²[0, i)
    cumulativeEnergy[0] = 0.0;

    // Both real signals in one complex FFT: real = x[0, W) zero-padded, imaginary = x[0, frameSamples)
    for (int i = 0; i < frameSamples; ++i)
    {
        float sample = buffer[(frameStart + i) % bufferSamples];

        fftBuffer[i] = std::complex<float>(i < integrationLength ? sample : 0.0f, sample);
        cumulativeEnergy[i + 1] = cumulativeEnergy[i] + static_cast<double>(sample) * sample;
    }

    FFT::forward(fftBuffer, twiddles);

    // Separate the two spectra via Hermitian symmetry; the cross-spectrum at N-k is the conjugate of the one at k
    for (int k = 0; k <= fftSamples / 2; ++k)
    {
        int mirror = (fftSamples - k) % fftSamples;

        std::complex<float> packed = fftBuffer[k];
        std::complex<float> packedMirror = std::conj(fftBuffer[mirror]);

        std::complex<float> integrationSpectrum = 0.5f * (packed + packedMirror);
        std::complex<float> frameSpectrum = std::complex<float>(0.0f, -0.5f) * (packed - packedMirror);
        std::complex<float> crossSpectrum = std::conj(integrationSpectrum) * frameSpectrum;

        fftBuffer[k] = crossSpectrum;
        fftBuffer[mirror] = std::conj(crossSpectrum);
    }

    FFT::reverse(fftBuffer, twiddles);

    double integrationEnergy = cumulativeEnergy[integrationLength];

    for (int lag = 0; lag < maxLag; ++lag)
    {
        double shiftedEnergy = cumulativeEnergy[lag + integrationLength] - cumulativeEnergy[lag];
        double crossCorrelation = fftBuffer[lag].real();
        double difference = integrationEnergy + shiftedEnergy - 2.0 * crossCorrelation;

        differences[lag] = static_cast<float>(std::max(0.0, difference));
    }

    return differences;
}

const std::vector<float> &YIN::CMNDF(const std::vector<float> &df)
{
    normalizedDifferences[0] = 1.0f;

    float sum = 0.0f;

    for (int lag = 1; lag < maxLag; ++lag)
    {
        sum += df[lag];

        normalizedDifferences[lag] = df[lag] * lag / (sum == 0.0f ? std::numeric_limits<float>::min() : sum);
    }

    return normalizedDifferences;
}

float YIN::energy()
{

    float result = 0.0f;

    int frameStart = (bufferPointer - frameSamples + bufferSamples) % bufferSamples;

    for (int k = 0; k < frameSamples; ++k)
    {
        int idx = (frameStart + k) % bufferSamples;

        float sample = buffer[idx];

        result += sample * sample;
    }

    return result / frameSamples;
}

float YIN::estimate()
{
    if (energy() < 2.7e-4f)
    {
        return -1.0f;
    }

    float threshold = 1e-1f;
    float unvoicedThreshold = 0.35f;

    const auto &df = DFARR();
    const auto &cmndf = CMNDF(df);

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

        int bestLag = minLag;
        float bestValue = cmndf[bestLag];

        for (int lag = minLag + 1; lag < maxLag; ++lag)
        {
            if (cmndf[lag] < bestValue)
            {
                bestLag = lag;
                bestValue = cmndf[bestLag];
            }
        }

        // Too aperiodic to be a pitch
        if (bestValue > unvoicedThreshold)
        {
            return -1.0f;
        }

        estimated = bestLag;
    }

    float estimateFloat = static_cast<float>(estimated);

    if (estimated > 0 && estimated + 1 < maxLag)
    {
        // Parabollic interpolation

        float y0 = df[estimated - 1];
        float y1 = df[estimated];
        float y2 = df[estimated + 1];

        float denominator = 2.0f * (y0 - 2.0f * y1 + y2);

        if (std::abs(denominator) > 1e-6f)
        {
            estimateFloat += (y0 - y2) / denominator;
        }
    }

    return sampleRate / estimateFloat;
}
