import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// No results state widget for parking list
class ParkingNoResultsState extends StatelessWidget {
  const ParkingNoResultsState({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final title = l10n.parkingStatusActive == 'Active'
        ? 'No results'
        : 'لا توجد نتائج';
    final subtitle = l10n.parkingStatusActive == 'Active'
        ? 'Try searching with different keywords'
        : 'جرب البحث بكلمات مختلفة';

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
                  EvaIcons.search,
                  size: 64.sp,
                  color: AppColors.secondaryText,
                ),
                SizedBox(height: 16.h),
                Text(
                  title,
                  style: AppTextStyles.titleMedium(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

