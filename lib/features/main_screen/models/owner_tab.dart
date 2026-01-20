import 'package:flutter/material.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../l10n/app_localizations.dart';

/// Owner bottom navigation tabs
enum OwnerTab {
  parkingManagement,
  profile,
}

extension OwnerTabX on OwnerTab {
  IconData get icon {
    switch (this) {
      case OwnerTab.parkingManagement:
        return AppIcons.parkings;
      case OwnerTab.profile:
        return AppIcons.profile;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case OwnerTab.parkingManagement:
        return AppIcons.parkingsSolid;
      case OwnerTab.profile:
        return AppIcons.profileSolid;
    }
  }

  String label(AppLocalizations l10n) {
    switch (this) {
      case OwnerTab.parkingManagement:
        return l10n.ownerTabParkingManagement;
      case OwnerTab.profile:
        return l10n.ownerTabProfile;
    }
  }

  int get index {
    switch (this) {
      case OwnerTab.parkingManagement:
        return 0;
      case OwnerTab.profile:
        return 1;
    }
  }
}

