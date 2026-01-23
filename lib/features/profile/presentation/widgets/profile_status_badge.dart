import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';

/// Reusable status badge widget for profile
class ProfileStatusBadge extends StatelessWidget {
  final String status;
  final bool isUserType;

  const ProfileStatusBadge({
    super.key,
    required this.status,
    this.isUserType = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelSmall(
          context,
          color: config.textColor,
        ),
      ),
    );
  }

  _StatusConfig _getStatusConfig() {
    if (isUserType) {
      return _StatusConfig(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        textColor: AppColors.primary,
      );
    }

    // Status badge
    if (status.toLowerCase() == 'active') {
      return _StatusConfig(
        backgroundColor: AppColors.success.withValues(alpha: 0.1),
        textColor: AppColors.success,
      );
    } else {
      return _StatusConfig(
        backgroundColor: AppColors.warning.withValues(alpha: 0.1),
        textColor: AppColors.warning,
      );
    }
  }
}

class _StatusConfig {
  final Color backgroundColor;
  final Color textColor;

  _StatusConfig({
    required this.backgroundColor,
    required this.textColor,
  });
}

