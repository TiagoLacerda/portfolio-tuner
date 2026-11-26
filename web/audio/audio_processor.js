// Samples per message to the main thread (~11 ms at 48 kHz)
const BUFFER_SIZE = 512;

class AudioProcessor extends AudioWorkletProcessor {
  buffer = new Float32Array(BUFFER_SIZE);
  filled = 0;

  process(inputs) {
    const samples = inputs[0]?.[0];

    if (!samples) {
      return true;
    }

    let offset = 0;

    while (offset < samples.length) {
      const count = Math.min(BUFFER_SIZE - this.filled, samples.length - offset);

      this.buffer.set(samples.subarray(offset, offset + count), this.filled);
      this.filled += count;
      offset += count;

      if (this.filled === BUFFER_SIZE) {
        this.port.postMessage(this.buffer, [this.buffer.buffer]);
        this.buffer = new Float32Array(BUFFER_SIZE);
        this.filled = 0;
      }
    }

    return true;
  }
}

registerProcessor('audio-processor', AudioProcessor);
