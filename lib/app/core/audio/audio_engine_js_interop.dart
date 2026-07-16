import 'dart:js_interop';

@JS('window.AudioBridge')
external AudioBridgeJS? get audioBridgeJS;

@JS()
@staticInterop
class AudioBridgeJS {}

extension AudioBridgeJSExt on AudioBridgeJS {
  external AudioEngineJS? createEngine();
}

@JS()
@staticInterop
class AudioEngineJS {}

extension AudioEngineJSExt on AudioEngineJS {
  external JSNumber get minFrequency;

  external JSNumber get maxFrequency;

  external JSPromise<JSBoolean> start();

  external void stop();

  external void dispose();

  external void onResult(JSFunction callback);
}
