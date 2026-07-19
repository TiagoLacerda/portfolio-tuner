import 'package:web/web.dart';

abstract class Cookie {
  static Map<String, String> get map {
    final cookies = <String, String>{};

    final raw = document.cookie;

    if (raw.isEmpty) return cookies;

    final parts = raw.split(';');

    for (final part in parts) {
      final cookie = part.trim();
      if (cookie.isEmpty) continue;

      final index = cookie.indexOf('=');
      if (index <= 0) continue;

      final key = cookie.substring(0, index).trim();
      final value = cookie.substring(index + 1);

      cookies[key] = Uri.decodeComponent(value);
    }

    return cookies;
  }

  static String? get(String key) => map[key];

  static void set(
    String key,
    String value, {
    String? domain,
  }) {
    var cookie = '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}; Path=/; SameSite=Lax';

    if (domain != null) cookie += '; Domain=$domain';

    document.cookie = cookie;
  }
}
