import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/create_booking/create_booking_bloc.dart';
import '../../../parking/models/parking_model.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../../vehicles/domain/entities/vehicle_entity.dart';
import '../../../vehicles/domain/usecases/get_vehicles_usecase.dart';
import '../widgets/booking_pre_payment_header.dart';
import '../widgets/booking_pre_payment_info_card.dart';
import '../widgets/booking_pre_payment_time_selector.dart';
import '../widgets/booking_pre_payment_vehicle_selector.dart';
import '../widgets/booking_pre_payment_price_summary.dart';
import '../widgets/booking_pre_payment_cta_button.dart';

/// Booking Pre-Payment Screen
/// UI screen for selecting time, vehicle, and reviewing booking details before payment
///
/// This screen allows users to:
/// - View parking details
/// - Select booking duration (1 hour, 2 hours, or custom)
/// - Select a vehicle
/// - Review total price
/// - Proceed to payment
class BookingPrePaymentScreen extends StatefulWidget {
  final ParkingModel parking;
  final List<VehicleModel> vehicles;

  const BookingPrePaymentScreen({
    super.key,
    required this.parking,
    required this.vehicles,
  });

  @override
  State<BookingPrePaymentScreen> createState() =>
      _BookingPrePaymentScreenState();
}

class _BookingPrePaymentScreenState extends State<BookingPrePaymentScreen> {
  int? _selectedVehicleId;
  int _selectedHours = 1;
  bool _isCustomTime = false;
  final TextEditingController _customHoursController = TextEditingController();
  late List<VehicleModel> _vehicles;

  @override
  void initState() {
    super.initState();
    _vehicles = widget.vehicles;
    // Initialize with first vehicle if available
    if (_vehicles.isNotEmpty) {
      _selectedVehicleId = _vehicles.first.vehicleId;
      // Update bloc with initial values
      context.read<CreateBookingBloc>().add(
        UpdateVehicleId(_vehicles.first.vehicleId),
      );
    }
    // Initialize hours
    context.read<CreateBookingBloc>().add(const UpdateHours(1));
    // Initialize lot ID
    context.read<CreateBookingBloc>().add(UpdateLotId(widget.parking.lotId));

    // Listen to custom hours input changes
    _customHoursController.addListener(_onCustomHoursChanged);
  }

  /// Refresh vehicles list after adding a new vehicle
  Future<void> _refreshVehicles() async {
    try {
      final getVehiclesUseCase = getIt<GetVehiclesUseCase>();
      final vehiclesEntities = await getVehiclesUseCase();

      // Convert entities to models
      final vehicles = vehiclesEntities
          .map((entity) => _vehicleEntityToModel(entity))
          .toList();

      setState(() {
        _vehicles = vehicles;
        // Select first vehicle if available and none selected
        if (_vehicles.isNotEmpty && _selectedVehicleId == null) {
          _selectedVehicleId = _vehicles.first.vehicleId;
          context.read<CreateBookingBloc>().add(
            UpdateVehicleId(_vehicles.first.vehicleId),
          );
        }
      });
    } catch (e) {
      debugPrint('Error refreshing vehicles: $e');
    }
  }

  /// Convert VehicleEntity to VehicleModel
  VehicleModel _vehicleEntityToModel(VehicleEntity entity) {
    return VehicleModel(
      vehicleId: entity.vehicleId,
      platNumber: entity.platNumber,
      carMake: entity.carMake,
      carModel: entity.carModel,
      color: entity.color,
      status: entity.status,
      requestStatus: entity.requestStatus,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  void dispose() {
    _customHoursController.dispose();
    super.dispose();
  }

  void _onCustomHoursChanged() {
    if (_isCustomTime && _customHoursController.text.isNotEmpty) {
      final hours = int.tryParse(_customHoursController.text) ?? 1;
      if (hours > 0) {
        setState(() {
          _selectedHours = hours;
        });
        context.read<CreateBookingBloc>().add(UpdateHours(hours));
      }
    }
  }

  void _onTimeSelected(int hours, bool isCustom) {
    setState(() {
      _selectedHours = hours;
      _isCustomTime = isCustom;
    });
    context.read<CreateBookingBloc>().add(UpdateHours(hours));
  }

  void _onVehicleSelected(int vehicleId) {
    setState(() {
      _selectedVehicleId = vehicleId;
    });
    context.read<CreateBookingBloc>().add(UpdateVehicleId(vehicleId));
  }

  void _onContinue() {
    if (_selectedVehicleId == null) {
      // Show error - vehicle must be selected
      return;
    }

    // Navigate to payment or submit booking
    // The bloc will handle the booking creation
    context.read<CreateBookingBloc>().add(SubmitCreateBooking());
  }

  double _calculateTotalPrice() {
    return widget.parking.hourlyRate * _selectedHours;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: BlocListener<CreateBookingBloc, CreateBookingState>(
        listener: (context, state) {
          if (state is CreateBookingSuccess) {
            // Navigate to payment or booking details
            context.pop();
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.bookingCreatedSuccess),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is CreateBookingFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

              return Column(
                children: [
                  // Scrollable content (including header)
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header with parking image and title - Now scrollable
                          BookingPrePaymentHeader(parking: widget.parking),

                          // Content padding
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 16.h),

                                // Parking Info Card
                                BookingPrePaymentInfoCard(
                                  parking: widget.parking,
                                ),

                                SizedBox(height: 24.h),

                                // Payment Hours Info
                                _buildPaymentHoursInfo(l10n),

                                SizedBox(height: 24.h),

                                // Time Selection Section
                                Text(
                                  l10n.bookingPrePaymentChooseTime,
                                  style: AppTextStyles.titleMedium(
                                    context,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                BookingPrePaymentTimeSelector(
                                  selectedHours: _selectedHours,
                                  isCustom: _isCustomTime,
                                  onTimeSelected: _onTimeSelected,
                                ),

                                // Custom hours input field
                                if (_isCustomTime) ...[
                                  SizedBox(height: 12.h),
                                  TextField(
                                    controller: _customHoursController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: 'أدخل عدد الساعات',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColors.surface,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 14.h,
                                      ),
                                    ),
                                  ),
                                ],

                                SizedBox(height: 24.h),

                                // Vehicle Selection Section
                                Text(
                                  l10n.bookingPrePaymentChooseVehicleRequired,
                                  style: AppTextStyles.titleMedium(
                                    context,
                                    color: AppColors.primaryText,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                BookingPrePaymentVehicleSelector(
                                  vehicles: _vehicles,
                                  selectedVehicleId: _selectedVehicleId,
                                  onVehicleSelected: _onVehicleSelected,
                                  onVehicleAdded: _refreshVehicles,
                                  parking: widget.parking,
                                ),

                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Price Summary and CTA - Adjust padding when keyboard is visible
                  Container(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 12.h,
                      bottom: keyboardHeight > 0 ? keyboardHeight + 12.h : 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BookingPrePaymentPriceSummary(
                          hourlyRate: widget.parking.hourlyRate,
                          hours: _selectedHours,
                          totalPrice: _calculateTotalPrice(),
                        ),
                        SizedBox(height: 12.h),
                        BookingPrePaymentCtaButton(
                          onPressed: _selectedVehicleId != null
                              ? _onContinue
                              : null,
                          isLoading:
                              context.watch<CreateBookingBloc>().state
                                  is CreateBookingLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHoursInfo(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 20.sp, color: AppColors.secondaryText),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.bookingPrePaymentPaymentHours,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
