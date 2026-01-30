import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../styles/app_colors.dart';
import '../utils/api_host_validator.dart';

/// Dialog that asks the user to enter the server host (IP or hostname:port).
/// Used on first launch (splash) and when "Change IP" is tapped on connection error.
class ServerHostInputDialog extends StatefulWidget {
  const ServerHostInputDialog({
    super.key,
    this.initialValue,
    this.title,
    this.hintText,
  });

  final String? initialValue;
  final String? title;
  final String? hintText;

  /// Shows the dialog and returns the entered host on confirm, or null on cancel.
  static Future<String?> show(
    BuildContext context, {
    String? initialValue,
    String? title,
    String? hintText,
  }) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ServerHostInputDialog(
        initialValue: initialValue,
        title: title,
        hintText: hintText,
      ),
    );
  }

  @override
  State<ServerHostInputDialog> createState() => _ServerHostInputDialogState();
}

class _ServerHostInputDialogState extends State<ServerHostInputDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    // Show only IP/host (no port) so user types just the IP
    final display = hostWithoutPort(widget.initialValue);
    _controller = TextEditingController(text: display);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final value = _controller.text.trim();
    if (!isValidApiHost(value)) {
      setState(() {
        _errorText = AppLocalizations.of(context)!.serverHostInvalidFormat;
      });
      return;
    }
    // Dismiss keyboard first, then close dialog
    FocusScope.of(context).unfocus();
    final hostWithPort = normalizeToHostPort(value);
    Navigator.of(context).pop(hostWithPort);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final title = widget.title ?? l10n.serverHostDialogTitle;
    final hint = widget.hintText ?? l10n.serverHostDialogHint;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: hint,
                errorText: _errorText,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              // Numeric keyboard with dot for IP (e.g. 192.168.1.5)
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                // Allow only digits and dot for IP-style input
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
              onSubmitted: (_) => _onConfirm(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            l10n.serverHostDialogCancel,
            style: TextStyle(color: theme.colorScheme.onSurface),
          ),
        ),
        FilledButton(
          onPressed: _onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.brightWhite,
          ),
          child: Text(l10n.serverHostDialogConfirm),
        ),
      ],
    );
  }
}
