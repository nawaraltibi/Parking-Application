import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../styles/app_colors.dart';
import '../utils/api_connection_error_handler.dart';
import 'server_host_input_dialog.dart';

/// Dialog shown when an API request fails with connection error or timeout.
/// Offers Retry (same host) and Change IP (opens host input dialog, then retry with new host).
class ApiConnectionErrorDialog extends StatelessWidget {
  const ApiConnectionErrorDialog({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(l10n.connectionErrorDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.connectionErrorDialogHint,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(ConnectionErrorCancel()),
          child: Text(
            l10n.serverHostDialogCancel,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        TextButton(
          onPressed: () => _onChangeIp(context),
          child: Text(l10n.connectionErrorChangeIp),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(ConnectionErrorRetry()),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.brightWhite,
          ),
          child: Text(l10n.connectionErrorRetry),
        ),
      ],
    );
  }

  Future<void> _onChangeIp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final newHost = await ServerHostInputDialog.show(
      context,
      title: l10n.serverHostDialogTitle,
      hintText: l10n.serverHostDialogHint,
    );
    if (!context.mounted) return;
    if (newHost != null && newHost.isNotEmpty) {
      Navigator.of(context).pop(ConnectionErrorRetryWithNewHost(newHost));
    }
  }
}
