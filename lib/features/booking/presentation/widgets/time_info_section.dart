import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';

/// Time Info Section Widget
/// Displays start and end time with proper formatting
class TimeInfoSection extends StatelessWidget {
  final BookingModel booking;

  const TimeInfoSection({
    super.key,
    required this.booking,
  });

  /// Parse date string to DateTime
  DateTime? _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      // Try ISO 8601 format first
      return DateTime.parse(dateString);
    } catch (e) {
      // If parsing fails, return null
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    
    final dateFormat = DateFormat('d MMMM yyyy', isArabic ? 'ar' : 'en');
    final timeFormat = DateFormat('h:mm a', isArabic ? 'ar' : 'en');

    final startTime = _parseDateTime(booking.startTime);
    final endTime = _parseDateTime(booking.endTime);

    if (startTime == null || endTime == null) {
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
        child: Row(
          children: [
            // Start Time Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_upward,
                        size: 16.sp,
                        color: AppColors.success,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.paymentStarts,
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        EvaIcons.calendarOutline,
                        size: 16.sp,
                        color: AppColors.secondaryText,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          dateFormat.format(startTime),
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        EvaIcons.clockOutline,
                        size: 16.sp,
                        color: AppColors.secondaryText,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          timeFormat.format(startTime),
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Divider
            Container(
              width: 1,
              height: 100.h,
              color: AppColors.border,
            ),
            
            SizedBox(width: 16.w),
            
            // End Time Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_downward,
                        size: 16.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.paymentEnds,
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        EvaIcons.calendarOutline,
                        size: 16.sp,
                        color: AppColors.secondaryText,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          dateFormat.format(endTime),
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        EvaIcons.clockOutline,
                        size: 16.sp,
                        color: AppColors.secondaryText,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          timeFormat.format(endTime),
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

