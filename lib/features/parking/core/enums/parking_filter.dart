import '../../../../l10n/app_localizations.dart';
import '../../models/parking_model.dart';

/// Parking filter options
enum ParkingFilter {
  all,
  active,
  pending;

  /// Get localized label for the filter
  String getLocalizedLabel(AppLocalizations l10n) {
    return switch (this) {
      ParkingFilter.all => l10n.parkingStatusActive == 'Active' ? 'All' : 'الكل',
      ParkingFilter.active => l10n.parkingStatusActive,
      ParkingFilter.pending => l10n.parkingStatusPending,
    };
  }

  /// Check if parking matches this filter
  bool matches(ParkingModel parking) {
    return switch (this) {
      ParkingFilter.all => true,
      ParkingFilter.active => parking.isApproved && parking.isActive,
      ParkingFilter.pending => parking.isPending,
    };
  }
}

