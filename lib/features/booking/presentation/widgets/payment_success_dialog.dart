import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Payment Success Dialog
/// Shows success message with options to view booking details or go to home
class PaymentSuccessDialog extends StatelessWidget {
  final int bookingId;
  final VoidCallback? onViewDetails;
  final VoidCallback? onGoToHome;

  const PaymentSuccessDialog({
    super.key,
    required this.bookingId,
    this.onViewDetails,
    this.onGoToHome,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 40.sp,
                color: AppColors.success,
              ),
            ),
            SizedBox(height: 20.h),

            // Success Message
            Text(
              l10n.paymentSuccessMessage,
              style: AppTextStyles.titleLarge(
                context,
                color: AppColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),

            // Question Text
            Text(
              l10n.paymentSuccessQuestion,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),

            // Action Buttons
            Row(
              children: [
                // View Details Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      l10n.paymentViewDetails,
                      style: AppTextStyles.labelLarge(
                        context,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Go to Home Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onGoToHome,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryText,
                      side: BorderSide(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      l10n.paymentGoToHome,
                      style: AppTextStyles.labelLarge(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

