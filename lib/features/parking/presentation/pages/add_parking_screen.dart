import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/parking_list_refresh_notifier.dart';
import '../../../../core/utils/auth_route_transitions.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/create_parking/create_parking_bloc.dart';
import '../../models/create_parking_request.dart';
import '../utils/parking_error_handler.dart';
import '../widgets/parking_form_fields.dart';
import 'map_location_picker_screen.dart';

/// Add Parking Screen
/// Form for adding a new parking lot
class AddParkingScreen extends StatefulWidget {
  const AddParkingScreen({super.key});

  @override
  State<AddParkingScreen> createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends State<AddParkingScreen> {
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
      AuthRouteTransitions.buildPageRoute<GeoPoint>(
        child: MapLocationPickerScreen(
          initialLatitude: _selectedLocation?.latitude,
          initialLongitude: _selectedLocation?.longitude,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
      // Unfocus so keyboard does not open on address field after closing map
      if (mounted) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
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

              // طلب تحديث القائمة قبل الانتقال حتى تُستدعى الـ API وتظهر آخر موقف
              getIt<ParkingListRefreshNotifier>().requestRefresh();

              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  context.goAndClearStack(Routes.ownerMainPath);
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
