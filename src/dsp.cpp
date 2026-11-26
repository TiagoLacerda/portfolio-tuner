// emcc src/yin/yin.cpp src/fft/fft.cpp src/dsp.cpp -O3 -s MODULARIZE=1 -s EXPORT_ES6=1 -s EXPORTED_FUNCTIONS='["_set_sample_rate","_process","_get_min_frequency","_get_max_frequency","_malloc","_free"]' -s EXPORTED_RUNTIME_METHODS='["HEAPF32"]' -o web/audio/dsp.js

#include <cmath>
#include <optional>

#include "yin/yin.hpp"

static const int minFrequency = 40;

// Nyquist, set once the sample rate is known
static int maxFrequency = 0;

static std::optional<YIN> yin;

extern "C"
{
    int get_min_frequency()
    {
        return minFrequency;
    }

    int get_max_frequency()
    {
        return maxFrequency;
    }

    void set_sample_rate(int sampleRate)
    {
        maxFrequency = sampleRate / 2;
        yin.emplace(minFrequency, maxFrequency, sampleRate);
    }

    float process(float *samples, int length)
    {
        if (!yin || samples == nullptr || length <= 0)
        {
            return -1.0f;
        }

        return yin->processBlock(samples, length);
    }
}
