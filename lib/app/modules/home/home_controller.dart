import 'package:material_ui/material_ui.dart';

import '../../core/audio/audio_engine.dart';

final class HomeController with ChangeNotifier {
  final _audioEngine = AudioEngine();

  bool get isAudioEngineRunning => _audioEngine.isRunning;

  double get minFrequency => _audioEngine.minFrequency ?? 40.0;

  double get maxFrequency => _audioEngine.maxFrequency ?? 20000.0;

  Stream<double> get stream => _audioEngine.estimates;

  void startAudioEngine() async {
    await _audioEngine.start();
    notifyListeners();
  }

  void stopAudioEngine() async {
    await _audioEngine.stop();
    notifyListeners();
  }

  @override
  void dispose() {
    _audioEngine.dispose();
    super.dispose();
  }
}
