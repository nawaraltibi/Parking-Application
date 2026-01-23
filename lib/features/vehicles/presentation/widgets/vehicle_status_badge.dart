import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle_entity.dart';

/// Vehicle Status Badge
/// Shows a compact status chip for vehicle state and modification status.
class VehicleStatusBadge extends StatelessWidget {
  final VehicleEntity vehicle;

  const VehicleStatusBadge({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final config = _getStatusConfig(vehicle, l10n);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        config.text,
        style: AppTextStyles.labelSmall(
          context,
          color: config.textColor,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(VehicleEntity v, AppLocalizations l10n) {
    // Modification request states take precedence
    if (v.isModificationRejected) {
      return _StatusConfig(
        text: l10n.vehiclesStatusRejected,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        textColor: AppColors.error,
      );
    }

    if (v.isModificationPending) {
      return _StatusConfig(
        text: l10n.vehiclesStatusPending,
        backgroundColor: AppColors.warning.withValues(alpha: 0.1),
        textColor: AppColors.warning,
      );
    }

    if (v.isInactive) {
      return _StatusConfig(
        text: l10n.vehiclesStatusInactive,
        backgroundColor: AppColors.secondaryText.withValues(alpha: 0.1),
        textColor: AppColors.secondaryText,
      );
    }

    return _StatusConfig(
      text: l10n.vehiclesStatusActive,
      backgroundColor: AppColors.success.withValues(alpha: 0.1),
      textColor: AppColors.success,
    );
  }
}

class _StatusConfig {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  _StatusConfig({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });
}


