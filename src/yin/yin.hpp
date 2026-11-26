#pragma once

#include <complex>
#include <vector>

#include "../fft/fft.hpp"

class YIN
{
public:
    /// @brief Construct an YIN algorithm engine that searchs for pitch in a specified range, provided a sample rate.
    YIN(int minFrequency, int maxFrequency, int sampleRate);

    float processBlock(float *samples, int length);

private:
    int sampleRate;
    int minLag;
    int maxLag;

    /// @brief Number of samples in each processed frame. Should be at least twice the maximum expected period (see: Nyquist).
    int frameSamples;
    int hopSamples;
    int fftSamples;

    int bufferSamples;
    int bufferPointer;
    int samplesSinceLastFrame;

    std::vector<float> buffer;
    std::vector<std::complex<float>> fftBuffer;
    std::vector<std::complex<float>> twiddles;

    std::vector<double> cumulativeEnergy;
    std::vector<float> differences;
    std::vector<float> normalizedDifferences;

    /// @brief Difference function, evaluated over [0, maxLag).
    const std::vector<float> &DFARR();

    /// @brief Cumulative mean-normalized difference function.
    const std::vector<float> &CMNDF(const std::vector<float> &df);

    float energy();

    float estimate();
};
