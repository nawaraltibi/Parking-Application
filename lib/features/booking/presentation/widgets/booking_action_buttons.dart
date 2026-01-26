import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Booking Action Buttons Widget
/// Fixed bottom action buttons for booking details screen
class BookingActionButtons extends StatelessWidget {
  final VoidCallback? onExtendBooking;
  final VoidCallback? onViewInvoice;
  final VoidCallback? onCancelBooking;
  final bool isActive;

  const BookingActionButtons({
    super.key,
    this.onExtendBooking,
    this.onViewInvoice,
    this.onCancelBooking,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Extend Booking Button (Primary)
            if (isActive && onExtendBooking != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onExtendBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.extendBooking,
                    style: AppTextStyles.buttonText(
                      context,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ),
            
            if (isActive && onExtendBooking != null) SizedBox(height: 12.h),
            
            // View Invoice Button
            if (onViewInvoice != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onViewInvoice,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(
                      color: AppColors.border,
                      width: 1,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    l10n.downloadInvoice,
                    style: AppTextStyles.buttonText(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            
            if (onViewInvoice != null && onCancelBooking != null) 
              SizedBox(height: 12.h),
            
            // Cancel Booking Button
            if (onCancelBooking != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onCancelBooking,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                      color: AppColors.error,
                      width: 1,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    l10n.cancelBooking,
                    style: AppTextStyles.buttonText(
                      context,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

