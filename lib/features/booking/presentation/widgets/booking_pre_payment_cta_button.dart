import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Booking Pre-Payment CTA Button Widget
/// Large primary button for continuing to payment
class BookingPrePaymentCtaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const BookingPrePaymentCtaButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.buttonDisabled,
          foregroundColor: AppColors.textOnPrimary,
          disabledForegroundColor: AppColors.buttonDisabledText,
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
            : Text(
                l10n.bookingPrePaymentContinue,
                style: AppTextStyles.labelLarge(
                  context,
                  color: onPressed != null
                      ? AppColors.textOnPrimary
                      : AppColors.buttonDisabledText,
                ),
              ),
      ),
    );
  }
}

