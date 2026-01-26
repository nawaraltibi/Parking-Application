import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/create_parking/create_parking_bloc.dart';
import '../../models/create_parking_request.dart';
import '../utils/parking_error_handler.dart';
import '../widgets/parking_form_fields.dart';
import 'map_location_picker_screen.dart';

/// Create Parking Screen
/// Form for creating a new parking lot
class CreateParkingScreen extends StatefulWidget {
  const CreateParkingScreen({super.key});

  @override
  State<CreateParkingScreen> createState() => _CreateParkingScreenState();
}

class _CreateParkingScreenState extends State<CreateParkingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _lotNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _totalSpacesController = TextEditingController();
  final _hourlyRateController = TextEditingController();

  // Selected location from map picker
  GeoPoint? _selectedLocation;

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

  void _handleCreate() {
    if (_formKey.currentState!.validate()) {
      // Validate location is selected
      if (_selectedLocation == null) {
        final l10n = AppLocalizations.of(context)!;
        UnifiedSnackbar.error(
          context,
          message: l10n.parkingLocationNotSelected,
        );
        return;
      }

      final request = CreateParkingRequest(
        lotName: _lotNameController.text.trim(),
        address: _addressController.text.trim(),
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        totalSpaces: int.tryParse(_totalSpacesController.text.trim()) ?? 0,
        hourlyRate: double.tryParse(_hourlyRateController.text.trim()) ?? 0.0,
      );

      context.read<CreateParkingBloc>().add(SubmitCreateParking(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.parkingCreateTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<CreateParkingBloc, CreateParkingState>(
          listener: (context, state) {
            // Success handling
            if (state is CreateParkingSuccess) {
              UnifiedSnackbar.success(
                context,
                message: l10n.parkingSuccessCreate,
              );

              // Navigate to owner main screen using pushReplacement
              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  context.pushReplacement(Routes.ownerMainPath);
                }
              });
            }

            // Error handling
            if (state is CreateParkingFailure) {
              final errorMessage = ParkingErrorHandler.handleErrorState(
                state.error,
                state.statusCode ?? 500,
                l10n,
              );
              UnifiedSnackbar.error(context, message: errorMessage);
            }
          },
          builder: (context, state) {
            final isLoading = state is CreateParkingLoading;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      title: l10n.parkingCreateButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _handleCreate,
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
