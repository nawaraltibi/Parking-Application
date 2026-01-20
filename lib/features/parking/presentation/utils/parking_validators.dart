import '../../../../l10n/app_localizations.dart';

/// Centralized validation logic for parking forms
class ParkingValidators {
  static String? lotName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.parkingValidationLotNameRequired;
    }
    return null;
  }

  static String? address(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.parkingValidationAddressRequired;
    }
    return null;
  }

  static String? totalSpaces(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.parkingValidationTotalSpacesInvalid;
    }
    final spaces = int.tryParse(value.trim());
    if (spaces == null || spaces < 1) {
      return l10n.parkingValidationTotalSpacesInvalid;
    }
    return null;
  }

  static String? hourlyRate(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.parkingValidationHourlyRateInvalid;
    }
    final rate = double.tryParse(value.trim());
    if (rate == null || rate < 0) {
      return l10n.parkingValidationHourlyRateInvalid;
    }
    return null;
  }
}

