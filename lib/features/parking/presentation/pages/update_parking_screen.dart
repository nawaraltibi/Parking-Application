import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/parking_cubit.dart';
import '../../models/parking_model.dart';
import '../../models/update_parking_request.dart';
import '../utils/parking_error_handler.dart';
import '../widgets/parking_form_fields.dart';
import 'map_location_picker_screen.dart';

/// Update Parking Screen
/// Form for updating an existing parking lot
class UpdateParkingScreen extends StatefulWidget {
  final ParkingModel parking;

  const UpdateParkingScreen({
    super.key,
    required this.parking,
  });

  @override
  State<UpdateParkingScreen> createState() => _UpdateParkingScreenState();
}

class _UpdateParkingScreenState extends State<UpdateParkingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _lotNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _totalSpacesController;
  late final TextEditingController _hourlyRateController;

  // Selected location from map picker (initialized with existing parking location)
  late GeoPoint? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _lotNameController = TextEditingController(text: widget.parking.lotName);
    _addressController = TextEditingController(text: widget.parking.address);
    _totalSpacesController = TextEditingController(text: widget.parking.totalSpaces.toString());
    _hourlyRateController = TextEditingController(text: widget.parking.hourlyRate.toString());

    // Initialize selected location with existing parking location
    _selectedLocation = GeoPoint(
      latitude: widget.parking.latitude,
      longitude: widget.parking.longitude,
    );
  }

  @override
  void dispose() {
    _lotNameController.dispose();
    _addressController.dispose();
    _totalSpacesController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<GeoPoint>(
      context,
      MaterialPageRoute(
        builder: (context) => MapLocationPickerScreen(
          initialLatitude: _selectedLocation?.latitude,
          initialLongitude: _selectedLocation?.longitude,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.parkingUpdateConfirmTitle),
        content: Text(l10n.parkingUpdateConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.profileCancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.parkingUpdateButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Validate location is selected
    if (_selectedLocation == null) {
      final l10n = AppLocalizations.of(context)!;
      UnifiedSnackbar.error(
        context,
        message: l10n.parkingLocationNotSelected,
      );
      return;
    }

    final request = UpdateParkingRequest(
      lotName: _lotNameController.text.trim(),
      address: _addressController.text.trim(),
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
      totalSpaces: int.tryParse(_totalSpacesController.text.trim()) ?? 0,
      hourlyRate: double.tryParse(_hourlyRateController.text.trim()) ?? 0.0,
    );

    context.read<ParkingCubit>().updateParking(widget.parking.lotId, request);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.parkingUpdateTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<ParkingCubit, ParkingState>(
          listener: (context, state) {
            if (state is ParkingUpdateSuccess) {
              UnifiedSnackbar.success(
                context,
                message: l10n.parkingSuccessUpdate,
              );
              
              // Reload all parkings from API to ensure latest data
              context.read<ParkingCubit>().loadParkings();
              
              // Navigate back after showing success message
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) {
                  context.pop();
                }
              });
            } else if (state is ParkingFailure) {
              final errorMessage = ParkingErrorHandler.handleErrorState(
                state.error,
                state.statusCode,
                l10n,
              );
              UnifiedSnackbar.error(context, message: errorMessage);
            }
          },
          builder: (context, state) {
            final isLoading = state is ParkingUpdating;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20.sp,
                            color: AppColors.warning,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              l10n.parkingUpdateRequiresApproval,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ParkingFormFields(
                      lotNameController: _lotNameController,
                      addressController: _addressController,
                      totalSpacesController: _totalSpacesController,
                      hourlyRateController: _hourlyRateController,
                      selectedLocation: _selectedLocation,
                      onLocationPickerTap: _openMapPicker,
                      enabled: !isLoading,
                    ),
                    SizedBox(height: 24.h),
                    CustomElevatedButton(
                      title: l10n.parkingUpdateButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _handleUpdate,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

