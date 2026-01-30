import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/booking_action/booking_action_bloc.dart';
import '../../models/booking_model.dart';
import '../widgets/extend_booking_info_card.dart';
import '../widgets/extend_booking_hour_selector.dart';
import '../widgets/extend_booking_price_summary.dart';
import '../widgets/extend_booking_confirm_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../parking/models/parking_model.dart';
import '../../../vehicles/data/models/vehicle_model.dart';

/// Extend Booking Screen
/// UI screen for extending an active booking
///
/// Flow:
/// 1. User selects extra hours
/// 2. System calculates total price
/// 3. User confirms extension
/// 4. API call to extend booking
/// 5. Navigate to payment screen
/// 6. After payment, return to booking details
class ExtendBookingScreen extends StatefulWidget {
  final BookingModel booking;
  /// مصدر الدخول لتفاصيل الحجز: 'home' | 'bookings' | 'pre_payment' — يمرر للدفع ثم لتفاصيل الحجز للرجوع الصحيح
  final String openedFrom;

  const ExtendBookingScreen({
    super.key,
    required this.booking,
    this.openedFrom = 'home',
  });

  @override
  State<ExtendBookingScreen> createState() => _ExtendBookingScreenState();
}

class _ExtendBookingScreenState extends State<ExtendBookingScreen> {
  int _selectedHours = 1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final parkingLot = widget.booking.parkingLot;
    final hourlyRate = parkingLot?.hourlyRate ?? 0.0;
    final totalPrice = _selectedHours * hourlyRate;

    return BlocProvider(
      create: (context) => getIt<BookingActionBloc>(),
      child: BlocListener<BookingActionBloc, BookingActionState>(
        listener: (context, state) {
          if (state is BookingActionLoading) {
            setState(() => _isLoading = true);
          } else if (state is BookingActionSuccess) {
            if (state.action == BookingActionType.extend) {
              _isLoading = false;
              // Navigate to payment screen
              // Note: We use the calculated totalPrice here
              // The API response should contain totalAmount, but we'll use local calculation
              // for now. If API returns totalAmount, we should use that instead.
              _navigateToPayment(context, state.bookingId, totalPrice);
            }
          } else if (state is BookingActionFailure) {
            setState(() => _isLoading = false);
            final l10n = AppLocalizations.of(context);
            final message = state.error == 'invalid_hours'
                ? (l10n?.errorInvalidHours ?? state.error)
                : state.error;
            UnifiedSnackbar.error(context, message: message);
          }
        },
        child: Builder(
          builder: (blocContext) => Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.primaryText,
                  size: 24.sp,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                l10n.extendBooking,
                style: AppTextStyles.titleLarge(
                  context,
                  color: AppColors.primaryText,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Booking Info Card
                    ExtendBookingInfoCard(booking: widget.booking),
                    SizedBox(height: 20.h),

                    // Hour Selector
                    Text(
                      l10n.selectExtraHours,
                      style: AppTextStyles.titleMedium(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ExtendBookingHourSelector(
                      selectedHours: _selectedHours,
                      onHoursChanged: (hours) {
                        setState(() => _selectedHours = hours);
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Price Summary
                    ExtendBookingPriceSummary(
                      selectedHours: _selectedHours,
                      hourlyRate: hourlyRate,
                      totalPrice: totalPrice,
                    ),
                    SizedBox(height: 20.h),

                    // Confirm Button
                    ExtendBookingConfirmButton(
                      onConfirm: _isLoading
                          ? null
                          : () => _confirmExtension(blocContext),
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmExtension(BuildContext context) {
    if (_selectedHours < 1) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        UnifiedSnackbar.error(context, message: l10n.errorInvalidHours);
      }
      return;
    }

    context.read<BookingActionBloc>().add(
      ExtendBooking(
        bookingId: widget.booking.bookingId,
        extraHours: _selectedHours,
      ),
    );
  }

  void _navigateToPayment(
    BuildContext context,
    int bookingId,
    double totalAmount,
  ) {
    // Navigate to payment screen
    // Use parking and vehicle from booking
    final parkingLot = widget.booking.parkingLot;
    final vehicle = widget.booking.vehicle;

    if (parkingLot == null || vehicle == null) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        UnifiedSnackbar.error(context, message: l10n.errorInvalidBookingId);
      }
      return;
    }

    // Convert ParkingLotInfo to ParkingModel
    final parking = ParkingModel(
      lotId: parkingLot.lotId,
      lotName: parkingLot.lotName,
      address: parkingLot.address ?? '',
      latitude: parkingLot.latitude ?? 0.0,
      longitude: parkingLot.longitude ?? 0.0,
      totalSpaces: parkingLot.totalSpaces ?? 0,
      hourlyRate: parkingLot.hourlyRate ?? 0.0,
      status: 'active', // Default status
    );

    // Convert VehicleInfo to VehicleModel
    final vehicleModel = VehicleModel(
      vehicleId: vehicle.vehicleId,
      platNumber: vehicle.platNumber,
      carMake: vehicle.carMake ?? '',
      carModel: vehicle.carModel ?? '',
      color: vehicle.color ?? '',
      status: 'active', // Default status
      requestStatus: 'accept', // Default request status
      userId: widget.booking.userId,
    );

    context.push(
      Routes.userMainBookingsPaymentPath,
      extra: {
        'parking': parking,
        'vehicle': vehicleModel,
        'hours': _selectedHours,
        'totalAmount': totalAmount,
        'bookingId': bookingId,
        'isExtension': true,
        'openedFrom': widget.openedFrom,
      },
    );
  }
}
