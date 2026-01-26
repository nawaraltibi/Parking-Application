import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';

/// Extend Booking Info Card Widget
/// Displays current booking information
class ExtendBookingInfoCard extends StatelessWidget {
  final BookingModel booking;

  const ExtendBookingInfoCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final parkingLot = booking.parkingLot;
    final vehicle = booking.vehicle;

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
            // Title
            Text(
              l10n.currentBooking,
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 16.h),

            // Parking Lot Name
            if (parkingLot != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      parkingLot.lotName,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  SizedBox(width: 28.w), // Align with icon above
                  Expanded(
                    child: Text(
                      parkingLot.address ?? '',
                      style: AppTextStyles.bodySmall(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
            ],

            // Vehicle Info
            if (vehicle != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 20.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '${vehicle.carMake} ${vehicle.carModel}',
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  SizedBox(width: 28.w), // Align with icon above
                  Text(
                    '${l10n.plateNumber}: ${vehicle.platNumber}',
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

