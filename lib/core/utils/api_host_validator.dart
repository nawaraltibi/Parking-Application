/// Default API port when user enters only IP/hostname (no port).
const int defaultApiPort = 8000;

/// Validates API host input.
///
/// Accepts:
/// - **IP only:** xxx.xxx.xxx.xxx (e.g. 192.168.1.5) — port will be added automatically.
/// - **Hostname only:** e.g. my-server.local — port will be added automatically.
/// - **Host:port:** xxx.xxx.xxx.xxx:port or hostname:port (port 1–65535).
bool isValidApiHost(String? value) {
  if (value == null || value.trim().isEmpty) return false;
  final trimmed = value.trim();
  final lastColon = trimmed.lastIndexOf(':');
  if (lastColon == trimmed.length - 1) return false; // ends with ':'
  String host;
  if (lastColon > 0) {
    host = trimmed.substring(0, lastColon).trim();
    final portStr = trimmed.substring(lastColon + 1).trim();
    if (host.isEmpty || portStr.isEmpty) return false;
    final port = int.tryParse(portStr);
    if (port == null || port < 1 || port > 65535) return false;
  } else {
    host = trimmed;
  }
  if (host.isEmpty) return false;
  // Host: allow letters, digits, dots, hyphens (for hostnames and IPs)
  if (!RegExp(r'^[a-zA-Z0-9.\-]+$').hasMatch(host)) return false;
  // If it looks like IPv4 (four segments), validate each octet 0–255
  final segments = host.split('.');
  if (segments.length == 4) {
    for (final s in segments) {
      final n = int.tryParse(s);
      if (n == null || n < 0 || n > 255) return false;
    }
  }
  return true;
}

/// Returns "host:port" for use with APIConfig. If input has no port, appends [defaultPort].
String normalizeToHostPort(String? value, {int defaultPort = defaultApiPort}) {
  if (value == null || value.trim().isEmpty) return '';
  final trimmed = value.trim();
  final lastColon = trimmed.lastIndexOf(':');
  if (lastColon > 0 && lastColon < trimmed.length - 1) {
    final portStr = trimmed.substring(lastColon + 1).trim();
    final port = int.tryParse(portStr);
    if (port != null && port >= 1 && port <= 65535) {
      return trimmed; // already has valid port
    }
  }
  return '$trimmed:$defaultPort';
}

/// Returns only the host part (no port) for display in the IP field.
/// e.g. "192.168.1.5:8000" -> "192.168.1.5"
String hostWithoutPort(String? value) {
  if (value == null || value.trim().isEmpty) return '';
  final trimmed = value.trim();
  final lastColon = trimmed.lastIndexOf(':');
  if (lastColon > 0) {
    final host = trimmed.substring(0, lastColon).trim();
    final portStr = trimmed.substring(lastColon + 1).trim();
    if (portStr.isNotEmpty && int.tryParse(portStr) != null) return host;
  }
  return trimmed;
}
