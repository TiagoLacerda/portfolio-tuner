# portfolio-tuner

A real-time instrument tuner for the browser. Pitch is estimated with the YIN algorithm, implemented in C++ and compiled to WebAssembly, and displayed by a Flutter web interface.

**[Live demo](https://portfolio-8b527-tuner.web.app)**

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/demo-dark.gif">
  <img alt="The tuner detecting a plucked A2 and the needle moving into tune" src="docs/demo-light.gif">
</picture>

## Highlights

- Microphone audio runs through an AudioWorklet into YIN compiled to WebAssembly, and the estimates stream into Flutter through a JavaScript bridge.
- YIN's difference function is computed in O(N log N) with a single packed complex FFT, instead of O(N·τ).
- Pitch is refined with parabolic interpolation and smoothed with a median filter.

## Running locally

```sh
flutter pub get
dart run modular_localization
flutter run -d chrome
```

The Emscripten command to rebuild the WebAssembly module is at the top of [`src/dsp.cpp`](src/dsp.cpp).

## License

[BSD 3-Clause](LICENSE)
