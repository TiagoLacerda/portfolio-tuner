// emcc src/yin/yin.cpp src/fft/fft.cpp src/dsp.cpp -O3 -s MODULARIZE=1 -s EXPORT_ES6=1 -s EXPORTED_FUNCTIONS='["_process","_get_min_frequency","_get_max_frequency","_malloc","_free"]' -s EXPORTED_RUNTIME_METHODS='["HEAPF32"]' -o web/audio/dsp.js

#include <cmath>

#include "yin/yin.hpp"

static const int minFrequency = 20;
static const int maxFrequency = 20000;

static YIN yin(minFrequency, maxFrequency, 48000);

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

    float process(float *samples, int length)
    {
        if (samples == nullptr || length <= 0)
        {
            return 0.0f;
        }

        return yin.processBlock(samples, length);
    }
}
