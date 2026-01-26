import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Extend Booking Hour Selector Widget
/// Allows user to select number of extra hours (1-5 or custom)
class ExtendBookingHourSelector extends StatefulWidget {
  final int selectedHours;
  final ValueChanged<int> onHoursChanged;

  const ExtendBookingHourSelector({
    super.key,
    required this.selectedHours,
    required this.onHoursChanged,
  });

  @override
  State<ExtendBookingHourSelector> createState() =>
      _ExtendBookingHourSelectorState();
}

class _ExtendBookingHourSelectorState
    extends State<ExtendBookingHourSelector> {
  final TextEditingController _customHoursController = TextEditingController();
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();
    // Check if selected hours is not in preset list (1-5)
    _isCustom = widget.selectedHours > 5;
    if (_isCustom) {
      _customHoursController.text = widget.selectedHours.toString();
    }
    _customHoursController.addListener(_onCustomHoursChanged);
  }

  @override
  void dispose() {
    _customHoursController.dispose();
    super.dispose();
  }

  void _onCustomHoursChanged() {
    final text = _customHoursController.text;
    if (text.isNotEmpty) {
      final hours = int.tryParse(text);
      if (hours != null && hours > 0) {
        widget.onHoursChanged(hours);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final presetHours = [1, 2, 3, 4, 5];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Preset Hours (1-5)
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: presetHours.map((hours) {
            final isSelected = !_isCustom && widget.selectedHours == hours;
            return InkWell(
              onTap: () {
                setState(() {
                  _isCustom = false;
                });
                widget.onHoursChanged(hours);
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  '$hours ${hours == 1 ? l10n.hour : l10n.hours}',
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.primaryText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),

        // Custom Hours Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customHoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.customHours,
                  hintText: l10n.enterHours,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
                onTap: () {
                  setState(() {
                    _isCustom = true;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

