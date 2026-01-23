import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../l10n/app_localizations.dart';

/// Vehicles Empty State
/// Modern empty state with icon, message and CTA.
class VehiclesEmptyState extends StatelessWidget {
  final VoidCallback? onAddTap;

  const VehiclesEmptyState({
    super.key,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 220.h,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.directions_car_outlined,
                  size: 80.sp,
                  color: AppColors.secondaryText,
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.vehiclesEmptyTitle,
                  style: AppTextStyles.titleLarge(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.vehiclesEmptySubtitle,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onAddTap != null) ...[
                  SizedBox(height: 32.h),
                  ElevatedButton.icon(
                    onPressed: onAddTap,
                    icon: Icon(AppIcons.addSolid),
                    label: Text(l10n.vehiclesAddTitle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
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


