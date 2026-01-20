import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/app_icons.dart';
import '../../../l10n/app_localizations.dart';

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
                  AppIcons.parking,
                  size: 80.sp,
                  color: AppColors.secondaryText,
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.parkingEmptyState,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.parkingEmptyStateSubtitle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (onCreateTap != null) ...[
                  SizedBox(height: 32.h),
                  ElevatedButton.icon(
                    onPressed: onCreateTap,
                    icon: Icon(AppIcons.addSolid),
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

