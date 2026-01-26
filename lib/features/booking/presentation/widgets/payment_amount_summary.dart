import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Payment Amount Summary Widget
/// Displays total amount with VAT information
class PaymentAmountSummary extends StatelessWidget {
  final double totalAmount;
  final VoidCallback? onConfirm;
  final bool isLoading;

  const PaymentAmountSummary({
    super.key,
    required this.totalAmount,
    this.onConfirm,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Required Amount Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.paymentRequiredAmount,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.primaryText,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.currencySymbol,
                    style: AppTextStyles.titleLarge(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    totalAmount.toStringAsFixed(2),
                    style: AppTextStyles.titleLarge(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          
          // VAT Note
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              l10n.bookingPrePaymentVatIncluded,
              style: AppTextStyles.bodySmall(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          
          // Confirm Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onConfirm,
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
                  : Text(
                      l10n.paymentConfirm,
                      style: AppTextStyles.labelLarge(
                        context,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

