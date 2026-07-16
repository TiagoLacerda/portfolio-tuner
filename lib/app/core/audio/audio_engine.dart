import 'dart:async';
import 'dart:js_interop';

import 'audio_engine_js_interop.dart';

final class AudioEngineException implements Exception {
  final String message;
  final Object? cause;

  const AudioEngineException(
    this.message, [
    this.cause,
  ]);

  @override
  String toString() {
    final cause = this.cause;

    if (cause == null) {
      return message;
    }

    return '$message: $cause';
  }
}

class AudioEngine {
  final _controller = StreamController<double>.broadcast();
  final AudioEngineJS? _engine;

  AudioEngine() : _engine = audioBridgeJS?.createEngine();

  Stream<double> get estimates => _controller.stream;
  bool get isRunning => _isStarted;
  double? get minFrequency => _engine?.minFrequency.toDartDouble;
  double? get maxFrequency => _engine?.maxFrequency.toDartDouble;

  JSFunction? _callback;
  bool _isStarted = false;

  Future<bool> start() async {
    if (_isStarted) {
      return true;
    }

    final engine = _engine;

    if (engine == null) {
      _fail(
        const AudioEngineException('AudioBridge not loaded'),
      );

      return false;
    }

    _callback ??= ((JSNumber value) {
      final valueAsDouble = value.toDartDouble;

      if (valueAsDouble >= 0) {
        _controller.add(
          valueAsDouble,
        );
      }
    }).toJS;

    engine.onResult(_callback!);

    try {
      final started = (await engine.start().toDart).toDart;
      _isStarted = started;

      if (!started) {
        _fail(
          const AudioEngineException('Microphone permission was not granted'),
        );
      }

      return started;
    } catch (error) {
      _fail(
        AudioEngineException(
          'Could not start audio engine',
          error,
        ),
      );

      return false;
    }
  }

  Future<void> stop() async {
    _engine?.stop();
    _isStarted = false;
  }

  Future<void> dispose() async {
    _engine?.dispose();
    _isStarted = false;

    await _controller.close();
  }

  void _fail(AudioEngineException error) {
    if (!_controller.isClosed) {
      _controller.addError(error);
    }
  }
}
