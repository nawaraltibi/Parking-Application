import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Empty state widget for parking list
class ParkingEmptyState extends StatelessWidget {
  final VoidCallback? onCreateTap;

  const ParkingEmptyState({
    super.key,
    this.onCreateTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 200.h,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  EvaIcons.mapOutline,
                  size: 100.sp,
                  color: AppColors.secondaryText.withValues(alpha: 0.6),
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.parkingEmptyState,
                  style: AppTextStyles.titleLarge(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.parkingEmptyStateSubtitle,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onCreateTap != null) ...[
                  SizedBox(height: 32.h),
                  ElevatedButton.icon(
                    onPressed: onCreateTap,
                    icon: Icon(EvaIcons.plusCircle),
                    label: Text(l10n.parkingCreateButton),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

