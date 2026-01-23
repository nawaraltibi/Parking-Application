import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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
        return EvaIcons.gridOutline;
      case OwnerTab.profile:
        return EvaIcons.personOutline;
    }
  }

  IconData get activeIcon {
    switch (this) {
      case OwnerTab.parkingManagement:
        return EvaIcons.grid;
      case OwnerTab.profile:
        return EvaIcons.person;
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

