import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Payment Action Buttons Widget
/// Displays Simulate Success and Simulate Failure buttons
class PaymentActionButtons extends StatelessWidget {
  final VoidCallback? onSimulateSuccess;
  final VoidCallback? onSimulateFailure;
  final bool isLoading;

  const PaymentActionButtons({
    super.key,
    this.onSimulateSuccess,
    this.onSimulateFailure,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Simulate Success Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSimulateSuccess,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.buttonDisabled,
              foregroundColor: AppColors.textOnPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.textOnPrimary,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 20.sp,
                        color: AppColors.textOnPrimary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.paymentSimulateSuccess,
                        style: AppTextStyles.labelLarge(
                          context,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        SizedBox(height: 12.h),
        
        // Simulate Failure Button
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            onPressed: isLoading ? null : onSimulateFailure,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 20.sp,
                  color: AppColors.error,
                ),
                SizedBox(width: 8.w),
                Text(
                  l10n.paymentSimulateFailure,
                  style: AppTextStyles.labelLarge(
                    context,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

