import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';

/// Vehicles Error State
class VehiclesErrorState extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const VehiclesErrorState({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: AppColors.error,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 24.w, end: 24.w),
            child: Text(
              error,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          if (onRetry != null) ...[
            SizedBox(height: 24.h),
            CustomElevatedButton(
              title: l10n.vehiclesRetryButton,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}


