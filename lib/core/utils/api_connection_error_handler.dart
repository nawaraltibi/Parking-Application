import 'package:flutter/material.dart';
import '../routes/app_pages.dart';
import '../widgets/api_connection_error_dialog.dart';

/// Result of showing the connection error dialog.
/// [retry] = user tapped Retry (same host).
/// [retryWithNewHost] = user tapped Change IP and entered a new host; caller should set host and retry.
/// [cancel] = user dismissed without retry.
sealed class ConnectionErrorResult {}

class ConnectionErrorRetry extends ConnectionErrorResult {}

class ConnectionErrorRetryWithNewHost extends ConnectionErrorResult {
  ConnectionErrorRetryWithNewHost(this.host);
  final String host;
}

class ConnectionErrorCancel extends ConnectionErrorResult {}

/// Shows the connection error dialog (Retry / Change IP) using the app navigator.
/// Call from DioProvider when a request fails with connection timeout or error.
/// Returns [ConnectionErrorRetry] or [ConnectionErrorRetryWithNewHost](host) or [ConnectionErrorCancel].
Future<ConnectionErrorResult> showConnectionErrorDialog(String message) async {
  final context = Pages.navigatorKey.currentContext;
  if (context == null || !context.mounted) return ConnectionErrorCancel();

  final result = await showDialog<ConnectionErrorResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => ApiConnectionErrorDialog(message: message),
  );
  return result ?? ConnectionErrorCancel();
}
