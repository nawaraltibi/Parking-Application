import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/parking_model.dart';

/// Reusable parking status badge widget
class ParkingStatusBadge extends StatelessWidget {
  final ParkingModel parking;

  const ParkingStatusBadge({
    super.key,
    required this.parking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final statusConfig = _getStatusConfig(l10n);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        statusConfig.text,
        style: AppTextStyles.labelSmall(
          context,
          color: statusConfig.textColor,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig(AppLocalizations l10n) {
    if (parking.isRejected) {
      return _StatusConfig(
        text: l10n.parkingStatusRejected,
        backgroundColor: AppColors.error.withValues(alpha: 0.1),
        textColor: AppColors.error,
      );
    } else if (parking.isPending) {
      return _StatusConfig(
        text: l10n.parkingStatusPending,
        backgroundColor: AppColors.warning.withValues(alpha: 0.1),
        textColor: AppColors.warning,
      );
    } else if (parking.isApproved && parking.isActive) {
      return _StatusConfig(
        text: l10n.parkingStatusActive,
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        textColor: AppColors.success,
      );
    } else {
      return _StatusConfig(
        text: l10n.parkingStatusInactive,
        backgroundColor: AppColors.secondaryText.withValues(alpha: 0.1),
        textColor: AppColors.secondaryText,
      );
    }
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

