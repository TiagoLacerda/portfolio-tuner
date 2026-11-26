import createModule from '/audio/dsp.js';

const wasm = await createModule();

class AudioEngine {
  listeners = new Set();
  audioContext = null;
  stream = null;
  source = null;
  node = null;
  bufferPointer = 0;
  bufferSamples = 0;

  get minFrequency() {
    return wasm._get_min_frequency();
  }

  get maxFrequency() {
    return wasm._get_max_frequency();
  }

  async start() {
    if (this.audioContext) {
      return true;
    }

    if (!navigator.mediaDevices?.getUserMedia) {
      return false;
    }

    try {
      this.stream = await navigator.mediaDevices.getUserMedia({
        audio: {
          echoCancellation: false,
          noiseSuppression: false,
          autoGainControl: false,
        },
      });
    } catch (error) {
      console.warn('Microphone access was not granted.', error);

      return false;
    }

    try {
      this.audioContext = new AudioContext();

      wasm._set_sample_rate(this.audioContext.sampleRate);

      await this.audioContext.audioWorklet.addModule(
        '/audio/audio_processor.js'
      );

      this.source =
        this.audioContext.createMediaStreamSource(this.stream);

      this.node = new AudioWorkletNode(
        this.audioContext,
        'audio-processor'
      );
    } catch (error) {
      console.warn('Could not initialize the audio engine.', error);
      this.stop();

      return false;
    }

    this.node.port.onmessage = (event) => {
      const samples = event.data;

      if (samples.length > this.bufferSamples) {
        wasm._free(this.bufferPointer);
        this.bufferPointer = wasm._malloc(samples.length * 4);
        this.bufferSamples = samples.length;
      }

      wasm.HEAPF32.set(samples, this.bufferPointer >> 2);

      const result = wasm._process(this.bufferPointer, samples.length);

      if (result < 0) {
        return;
      }

      for (const listener of this.listeners) {
        listener(result);
      }
    };

    this.source.connect(this.node);

    return true;
  }

  stop() {
    this.node?.disconnect();
    this.source?.disconnect();

    this.stream?.getTracks().forEach(
      (track) => track.stop(),
    );

    this.audioContext?.close();

    this.node = null;
    this.source = null;
    this.stream = null;
    this.audioContext = null;
  }

  onResult(callback) {
    this.listeners.add(callback);
  }

  dispose() {
    this.stop();
    this.listeners.clear();

    wasm._free(this.bufferPointer);
    this.bufferPointer = 0;
    this.bufferSamples = 0;
  }
}

window.AudioBridge = {
  createEngine() {
    return new AudioEngine();
  },
};
