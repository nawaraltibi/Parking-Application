import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Payment Notes Section Widget
/// Displays information about payment simulation
class PaymentNotesSection extends StatelessWidget {
  const PaymentNotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20.sp,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                l10n.paymentSimulationNote,
                style: AppTextStyles.titleMedium(
                  context,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          
          // Description
          Text(
            l10n.paymentSimulationDescription,
            style: AppTextStyles.bodySmall(
              context,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

