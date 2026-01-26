import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../parking/models/parking_model.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../../vehicles/presentation/utils/vehicle_translations.dart';

/// Payment Booking Info Card Widget
/// Displays parking and vehicle information in payment screen
class PaymentBookingInfoCard extends StatelessWidget {
  final ParkingModel parking;
  final VehicleModel vehicle;
  final DateTime startTime;
  final DateTime endTime;

  const PaymentBookingInfoCard({
    super.key,
    required this.parking,
    required this.vehicle,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final dateFormat = DateFormat('d MMMM yyyy', Localizations.localeOf(context).languageCode == 'ar' ? 'ar' : 'en');
    final timeFormat = DateFormat('h:mm a', Localizations.localeOf(context).languageCode == 'ar' ? 'ar' : 'en');

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
            // Parking Name
            Text(
              parking.lotName,
              style: AppTextStyles.titleLarge(
                context,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 8.h),
            
            // Location
            Row(
              children: [
                Icon(
                  EvaIcons.pin,
                  size: 16.sp,
                  color: AppColors.secondaryText,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    parking.address,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.secondaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Vehicle Info
            Row(
              children: [
                // Vehicle Icon
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.directions_car,
                    size: 24.sp,
                    color: AppColors.secondaryText,
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${VehicleTranslations.getCarMakeTranslation(vehicle.carMake, l10n)} ${vehicle.carModel}',
                        style: AppTextStyles.titleMedium(
                          context,
                          color: AppColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        vehicle.platNumber,
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Time Section
            Row(
              children: [
                // Start Time
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
                          SizedBox(width: 4.w),
                          Text(
                            l10n.paymentStarts,
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            EvaIcons.calendarOutline,
                            size: 16.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            dateFormat.format(startTime),
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            EvaIcons.clockOutline,
                            size: 16.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            timeFormat.format(startTime),
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.primaryText,
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
                  height: 80.h,
                  color: AppColors.border,
                ),
                
                SizedBox(width: 16.w),
                
                // End Time
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
                          SizedBox(width: 4.w),
                          Text(
                            l10n.paymentEnds,
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            EvaIcons.calendarOutline,
                            size: 16.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            dateFormat.format(endTime),
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            EvaIcons.clockOutline,
                            size: 16.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            timeFormat.format(endTime),
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.primaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
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

