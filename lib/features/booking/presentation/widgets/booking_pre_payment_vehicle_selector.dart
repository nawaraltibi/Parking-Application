import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../../vehicles/presentation/utils/vehicle_translations.dart';
import '../../../parking/models/parking_model.dart';

/// Booking Pre-Payment Vehicle Selector Widget
/// Displays list of vehicles with radio selection
class BookingPrePaymentVehicleSelector extends StatelessWidget {
  final List<VehicleModel> vehicles;
  final int? selectedVehicleId;
  final Function(int vehicleId) onVehicleSelected;
  final VoidCallback? onVehicleAdded;
  final ParkingModel? parking; // For passing to add vehicle page

  const BookingPrePaymentVehicleSelector({
    super.key,
    required this.vehicles,
    this.selectedVehicleId,
    required this.onVehicleSelected,
    this.onVehicleAdded,
    this.parking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (vehicles.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Center(
          child: Text(
            l10n?.bookingNoVehiclesAvailable ?? 'No vehicles available',
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.secondaryText,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        ...vehicles.map((vehicle) {
          final isSelected = selectedVehicleId == vehicle.vehicleId;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _VehicleCard(
              vehicle: vehicle,
              isSelected: isSelected,
              onTap: () => onVehicleSelected(vehicle.vehicleId),
            ),
          );
        }),

        // Add New Vehicle Button
        Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: InkWell(
            onTap: () async {
              await context.push(
                Routes.userMainVehiclesAddPath,
                extra: {
                  'source': 'booking_pre_payment',
                  'returnData': parking != null
                      ? {'parking': parking, 'vehicles': vehicles}
                      : null,
                },
              );
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 24.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    l10n?.bookingAddNewVehicle ?? 'Add New Vehicle',
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Vehicle Card Widget
class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleCard({
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio Button
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : AppColors.surface,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: AppColors.textOnPrimary,
                    )
                  : null,
            ),
            SizedBox(width: 16.w),

            // Vehicle Icon (Car instead of truck)
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
            SizedBox(width: 16.w),

            // Vehicle Details - Better text alignment
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${VehicleTranslations.getCarMakeTranslation(vehicle.carMake, AppLocalizations.of(context))} ${vehicle.carModel}',
                    style: AppTextStyles.titleMedium(
                      context,
                      color: AppColors.primaryText,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    vehicle.platNumber,
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.secondaryText,
                    ),
                    textAlign: TextAlign.start,
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
