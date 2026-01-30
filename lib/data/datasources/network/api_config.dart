import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// API configuration for the parking app.
///
/// The API host is loaded from SharedPreferences at startup when
/// [useDynamicApiHost] is true. When false, [host] is always [_debugHostFallback].
///
/// **Initialization:** Call [init] once before using any getters (e.g. in [main]).
class APIConfig {
  APIConfig._();

  static const String _hostKey = 'api_config_host';

  /// When **true**: show dialog to enter server host on first launch and on
  /// connection error (Change IP). Host is saved in SharedPreferences.
  /// When **false**: base URL is fixed ([_debugHostFallback]), no dialog.
  /// Change to false if the client wants a fixed API URL only.
  static const bool useDynamicApiHost = true;

  /// Fallback when no host is stored, or when [useDynamicApiHost] is false (fixed URL).
  static const String _debugHostFallback =
      'unchildlike-yolonda-nonelementary.ngrok-free.dev:443';

  /// Default host for getters when init not called or no stored value.
  static String get defaultHost => _debugHostFallback;

  static String? _host;
  static bool _initialized = false;
  static bool _hasStoredHost = false;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Loads the host and caches it.
  /// When [useDynamicApiHost] is false: always uses [_debugHostFallback] (fixed URL).
  /// When true: loads from SharedPreferences; if none stored, uses fallback (splash shows dialog).
  static Future<void> init() async {
    if (_initialized) return;
    if (!useDynamicApiHost) {
      _host = _debugHostFallback;
      _hasStoredHost = true; // treat as fixed, no dialog
      _initialized = true;
      if (kDebugMode) debugPrint('APIConfig: fixed host → $_debugHostFallback');
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    _host = prefs.getString(_hostKey);
    _hasStoredHost = _host != null && _host!.isNotEmpty;
    _host ??= _debugHostFallback;
    _initialized = true;
    if (kDebugMode) debugPrint('APIConfig: host → $host (stored: $_hasStoredHost)');
  }

  /// True if a host has been saved in SharedPreferences (user has set it at least once).
  static bool get hasStoredHost => _hasStoredHost;

  // ---------------------------------------------------------------------------
  // Async host access
  // ---------------------------------------------------------------------------

  static Future<String> getHostAsync() async {
    await init();
    return _host!;
  }

  static Future<void> setHost(String host) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_hostKey, host);
    _host = host;
    _hasStoredHost = true;
    _initialized = true;
    if (kDebugMode) debugPrint('APIConfig: host updated to $host');
  }

  // ---------------------------------------------------------------------------
  // Synchronous getters
  // ---------------------------------------------------------------------------

  static String get host => _host ?? defaultHost;

  /// Base URL: HTTPS for ngrok (port 443), HTTP for local.
  static String get baseUrl =>
      host.contains(':443') ? 'https://$host' : 'http://$host';

  static String get appAPI => '$baseUrl/api';

  static String getFullImageUrl(String imagePath) {
    if (imagePath.startsWith('https://') || imagePath.startsWith('http://')) {
      return imagePath;
    }
    return '$baseUrl$imagePath';
  }
}
