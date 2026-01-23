import '../../../../l10n/app_localizations.dart';

/// Centralized error handling for vehicles feature (UI-level mapping)
class VehiclesErrorHandler {
  /// Handles error state and formats message with vehicles-specific translations
  static String handleErrorState(
    String error,
    int statusCode,
    AppLocalizations l10n,
  ) {
    switch (statusCode) {
      case 401:
        return l10n.vehiclesErrorUnauthorized;
      case 403:
        return l10n.vehiclesErrorForbidden;
      case 422:
        // Prefer inline validation messages if backend provides them
        return error.isNotEmpty ? error : l10n.vehiclesErrorValidation;
      default:
        // 500 and any other unexpected status codes
        return error.isNotEmpty ? error : l10n.vehiclesErrorServer;
    }
  }
}


