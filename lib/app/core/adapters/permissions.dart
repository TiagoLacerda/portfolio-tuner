import 'dart:js_interop';

import '../enums/permission_status.dart';

@JS('navigator.permissions')
external JSPermissions? get permissions;

extension type JSPermissions(JSObject _) implements JSObject {
  external JSPromise<JSPermissionStatus> query(
    JSPermissionDescriptor descriptor,
  );
}

extension type JSPermissionDescriptor._(JSObject _) implements JSObject {
  external factory JSPermissionDescriptor({
    String name,
  });
}

extension type JSPermissionStatus(JSObject _) implements JSObject {
  external String get state;
}

Future<PermissionStatus> microphonePermission() async {
  final permissionApi = permissions;

  if (permissionApi == null) {
    return PermissionStatus.unsupported;
  }

  try {
    final status = await permissionApi
        .query(
          JSPermissionDescriptor(name: 'microphone'),
        )
        .toDart;

    return switch (status.state) {
      'granted' => PermissionStatus.granted,
      'denied' => PermissionStatus.denied,
      'prompt' => PermissionStatus.prompt,
      _ => PermissionStatus.unsupported,
    };
  } catch (_) {
    return PermissionStatus.unsupported;
  }
}
