import '../../../../l10n/app_localizations.dart';

/// Centralized validation logic for auth forms
class AuthValidators {
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authValidationEmailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return l10n.authValidationEmailInvalid;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.authValidationPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.authValidationPasswordShort;
    }
    return null;
  }

  static String? fullName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authValidationFullNameRequired;
    }
    if (value.length > 255) {
      return l10n.authValidationFullNameLong;
    }
    return null;
  }

  static String? phone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authValidationPhoneRequired;
    }
    return null;
  }

  static String? passwordConfirmation(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.authValidationPasswordConfirmationRequired;
    }
    if (value != password) {
      return l10n.authValidationPasswordMismatch;
    }
    return null;
  }
}

