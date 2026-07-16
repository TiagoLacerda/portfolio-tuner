import 'dart:math';

abstract final class TunerUtils {
  static double frequencyToMidi(double value) {
    return 69.0 + 12.0 * log(value / 440.0) / ln2;
  }

  static double midiToFrequency(double value) {
    return 440.0 * pow(2.0, (value - 69.0) / 12.0);
  }

  static String midiToString(double value) {
    final notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final bin = value.round();
    final note = notes[bin % 12];
    final octave = (bin ~/ 12) - 1;
    return '$note$octave';
  }
}
