import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Booking Pre-Payment Time Selector Widget
/// Allows selection of booking duration (1 hour, 2 hours, or custom)
class BookingPrePaymentTimeSelector extends StatelessWidget {
  final int selectedHours;
  final bool isCustom;
  final Function(int hours, bool isCustom) onTimeSelected;

  const BookingPrePaymentTimeSelector({
    super.key,
    required this.selectedHours,
    required this.isCustom,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Check if RTL (Arabic)
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Order buttons based on RTL
    List<_TimeOptionButton> buttons = [
      _TimeOptionButton(
        label: l10n.bookingPrePaymentTimeCustom,
        isSelected: isCustom,
        onTap: () => onTimeSelected(1, true),
      ),
      _TimeOptionButton(
        label: l10n.bookingPrePaymentTime2Hours,
        isSelected: !isCustom && selectedHours == 2,
        onTap: () => onTimeSelected(2, false),
      ),
      _TimeOptionButton(
        label: l10n.bookingPrePaymentTime1Hour,
        isSelected: !isCustom && selectedHours == 1,
        onTap: () => onTimeSelected(1, false),
      ),
    ];

    // Reverse order for RTL
    if (isRTL) {
      buttons = buttons.reversed.toList();
    }

    return Row(
      children: [
        Expanded(child: buttons[0]),
        SizedBox(width: 12.w),
        Expanded(child: buttons[1]),
        SizedBox(width: 12.w),
        Expanded(child: buttons[2]),
      ],
    );
  }
}

/// Time Option Button
class _TimeOptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeOptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.labelLarge(
              context,
              color: isSelected
                  ? AppColors.textOnPrimary
                  : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

