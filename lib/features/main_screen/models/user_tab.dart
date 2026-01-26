import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

/// User bottom navigation tabs
enum UserTab {
  home,
  vehicles,
  bookings,
  parkings,
  profile,
}

extension UserTabX on UserTab {
  IconData get icon {
    switch (this) {
      case UserTab.home:
        return Icons.home_outlined;
      case UserTab.vehicles:
        return Icons.directions_car_outlined;
      case UserTab.bookings:
        return Icons.local_parking_outlined;
      case UserTab.parkings:
        return Icons.bookmark_outline;
      case UserTab.profile:
        return Icons.person_outline;
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case UserTab.home:
        return l10n.userTabHome;
      case UserTab.vehicles:
        return l10n.userTabVehicles;
      case UserTab.bookings:
        return l10n.userTabBookings;
      case UserTab.parkings:
        return l10n.userTabParkings;
      case UserTab.profile:
        return l10n.userTabProfile;
    }
  }

  int get index {
    switch (this) {
      case UserTab.home:
        return 0;
      case UserTab.vehicles:
        return 1;
      case UserTab.bookings:
        return 2;
      case UserTab.parkings:
        return 3;
      case UserTab.profile:
        return 4;
    }
  }
}

