import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import '../../../vehicles/presentation/utils/vehicle_translations.dart';

/// Vehicle Info Card Widget
/// Displays vehicle details (plate number, make, model, color)
class VehicleInfoCard extends StatelessWidget {
  final BookingModel booking;

  const VehicleInfoCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final vehicle = booking.vehicle;
    if (vehicle == null) {
      return const SizedBox.shrink();
    }

    final carMake = vehicle.carMake ?? '';
    final carModel = vehicle.carModel ?? '';
    final plateNumber = vehicle.platNumber;
    final color = vehicle.color;

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
            // Vehicle Icon and Make/Model
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
                    size: 32.sp,
                    color: AppColors.primaryText,
                  ),
                ),
                SizedBox(width: 16.w),
                
                // Vehicle Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        carMake.isNotEmpty && carModel.isNotEmpty
                            ? '${VehicleTranslations.getCarMakeTranslation(carMake, l10n)} $carModel'
                            : (carMake.isNotEmpty 
                                ? VehicleTranslations.getCarMakeTranslation(carMake, l10n)
                                : carModel),
                        style: AppTextStyles.titleMedium(
                          context,
                          color: AppColors.primaryText,
                        ),
                      ),
                      if (color != null && color.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          VehicleTranslations.getColorTranslation(color, l10n),
                          style: AppTextStyles.bodySmall(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            
            // Divider
            Divider(
              color: AppColors.border,
              height: 1,
            ),
            SizedBox(height: 16.h),
            
            // Plate Number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.vehiclesFormPlateLabel,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
                Text(
                  plateNumber,
                  style: AppTextStyles.titleMedium(
                    context,
                    color: AppColors.primaryText,
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

