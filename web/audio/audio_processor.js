class AudioProcessor extends AudioWorkletProcessor {
  process(inputs) {
    const samples = inputs[0]?.[0];

    if (samples) {
      this.port.postMessage(new Float32Array(samples));
    }

    return true;
  }
}

registerProcessor('audio-processor', AudioProcessor);