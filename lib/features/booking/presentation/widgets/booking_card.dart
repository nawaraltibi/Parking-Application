import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import '../../../vehicles/presentation/utils/vehicle_translations.dart';

/// Booking Card Widget
/// Displays a single booking in the list with enhanced design
class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final parkingLot = booking.parkingLot;
    final vehicle = booking.vehicle;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          // Soft primary-colored shadow
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Standard soft shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to booking details
            context.push(
              Routes.bookingDetailsPath,
              extra: {'bookingId': booking.bookingId},
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.primary.withValues(alpha: 0.06),
          highlightColor: AppColors.primary.withValues(alpha: 0.03),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parking lot image placeholder with enhanced design
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.local_parking,
                    color: AppColors.primary,
                    size: 44.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                // Booking details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parking lot name
                      if (parkingLot != null)
                        Text(
                          parkingLot.lotName,
                          style: AppTextStyles.titleMedium(
                            context,
                            color: AppColors.primaryText,
                          ).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 6.h),
                      // Address
                      if (parkingLot?.address != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                parkingLot!.address!,
                                style: AppTextStyles.bodySmall(
                                  context,
                                  color: AppColors.secondaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 8.h),
                      // Date
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            _formatDate(booking.startTime),
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Vehicle info with enhanced design
                      if (vehicle != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 16.sp,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6.w),
                              // Vehicle type (make + model) - comes first
                              if (vehicle.carMake != null || vehicle.carModel != null) ...[
                                Flexible(
                                  child: Text(
                                    _getVehicleType(vehicle, context),
                                    style: AppTextStyles.bodySmall(
                                      context,
                                      color: AppColors.secondaryText,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  width: 1,
                                  height: 14.h,
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                ),
                                SizedBox(width: 8.w),
                              ],
                              // Plate number - comes after vehicle type
                              Text(
                                vehicle.platNumber,
                                style: AppTextStyles.bodySmall(
                                  context,
                                  color: AppColors.primaryText,
                                ).copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: 10.h),
                      // Amount with enhanced design
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            l10n.amount,
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              '${booking.totalAmount.toStringAsFixed(2)} ${l10n.currencySymbol}',
                              style: AppTextStyles.titleMedium(
                                context,
                                color: AppColors.primary,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final formatter = DateFormat('d MMMM yyyy', 'ar');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _getVehicleType(VehicleInfo vehicle, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final parts = <String>[];
    if (vehicle.carMake != null && vehicle.carMake!.isNotEmpty) {
      // Get translated car make based on current locale
      final carMakeTranslated = VehicleTranslations.getCarMakeTranslation(
        vehicle.carMake!,
        l10n,
      );
      parts.add(carMakeTranslated);
    }
    if (vehicle.carModel != null && vehicle.carModel!.isNotEmpty) {
      parts.add(vehicle.carModel!);
    }
    return parts.join(' ');
  }
}
