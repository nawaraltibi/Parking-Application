import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Payment Details Card Widget
/// Displays parking fees and selected payment method
class PaymentDetailsCard extends StatelessWidget {
  final double amount;
  final String selectedPaymentMethod;
  final VoidCallback? onPaymentMethodChange;

  const PaymentDetailsCard({
    super.key,
    required this.amount,
    required this.selectedPaymentMethod,
    this.onPaymentMethodChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      color: AppColors.surface,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking Fees Label
            Text(
              l10n.paymentParkingFees,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 8.h),
            
            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.paymentSelectedMethod,
                  style: AppTextStyles.bodySmall(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currencySymbol,
                      style: AppTextStyles.titleMedium(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      amount.toStringAsFixed(2),
                      style: AppTextStyles.titleMedium(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            
            // Selected Payment Method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getPaymentMethodName(l10n),
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.primaryText,
                  ),
                ),
                if (onPaymentMethodChange != null)
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                    onPressed: onPaymentMethodChange,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            
            // Payment Logos (if credit/online)
            if (selectedPaymentMethod == 'online')
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Image.asset(
                  'assets/images/paypal.png',
                  width: 60.w,
                  height: 36.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: Text(
                          'PayPal',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (selectedPaymentMethod == 'credit')
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/visa.png',
                      width: 50.w,
                      height: 30.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              'VISA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    Image.asset(
                      'assets/images/master_card.png',
                      width: 50.w,
                      height: 30.h,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 50.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: Text(
                              'MC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodName(AppLocalizations l10n) {
    switch (selectedPaymentMethod) {
      case 'cash':
        return l10n.paymentMethodCash;
      case 'credit':
        return l10n.paymentMethodCredit;
      case 'online':
        return l10n.paymentMethodOnline;
      default:
        return selectedPaymentMethod;
    }
  }
}

