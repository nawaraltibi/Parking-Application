import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/parking_list_refresh_notifier.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/auth_route_transitions.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/update_parking/update_parking_bloc.dart';
import '../../models/parking_model.dart';
import '../../models/update_parking_request.dart';
import '../utils/parking_error_handler.dart';
import '../widgets/parking_form_fields.dart';
import 'map_location_picker_screen.dart';

/// Update Parking Screen
/// Form for updating an existing parking lot
class UpdateParkingScreen extends StatefulWidget {
  final ParkingModel parking;

  const UpdateParkingScreen({super.key, required this.parking});

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
    _totalSpacesController = TextEditingController(
      text: widget.parking.totalSpaces.toString(),
    );
    _hourlyRateController = TextEditingController(
      text: widget.parking.hourlyRate.toString(),
    );

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
      if (mounted) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 320.w, maxWidth: 380.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: AppColors.brightWhite,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    EvaIcons.alertCircleOutline,
                    size: 32.sp,
                    color: AppColors.warning,
                  ),
                ),
                SizedBox(height: 20.h),
                // Title
                Text(
                  l10n.parkingUpdateConfirmTitle,
                  style: AppTextStyles.titleLarge(context),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                // Message
                Text(
                  l10n.parkingUpdateConfirmMessage,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ).copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      flex: 2, // زدنا من مساحة زر Cancel
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 2.w,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          side: BorderSide(
                            color: AppColors.border.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          l10n.profileCancelButton,
                          style: AppTextStyles.labelLarge(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex:
                          3, // قللنا شوي من مساحة Update (مثلاً خليها 3 بدل 3.5 لو تحب)
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 14.h,
                            horizontal: 5.w,
                          ),
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.parkingUpdateButton,
                          style: AppTextStyles.buttonText(
                            context,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (confirmed != true) return;

    // Validate location is selected
    if (_selectedLocation == null) {
      final l10n = AppLocalizations.of(context)!;
      UnifiedSnackbar.error(context, message: l10n.parkingLocationNotSelected);
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

    context.read<UpdateParkingBloc>().add(
      SubmitUpdateParking(parkingId: widget.parking.lotId, request: request),
    );
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
        child: BlocConsumer<UpdateParkingBloc, UpdateParkingState>(
          listener: (context, state) {
            // Success handling
            if (state is UpdateParkingSuccess) {
              UnifiedSnackbar.success(
                context,
                message: l10n.parkingSuccessUpdate,
              );

              getIt<ParkingListRefreshNotifier>().requestRefresh();

              Future.delayed(const Duration(milliseconds: 100), () {
                if (mounted) {
                  context.goAndClearStack(Routes.ownerMainPath);
                }
              });
            }

            // Error handling
            if (state is UpdateParkingFailure) {
              final errorMessage = ParkingErrorHandler.handleErrorState(
                state.error,
                state.statusCode ?? 500,
                l10n,
              );
              UnifiedSnackbar.error(context, message: errorMessage);
            }
          },
          builder: (context, state) {
            final isLoading = state is UpdateParkingLoading;

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
                            EvaIcons.infoOutline,
                            size: 20.sp,
                            color: AppColors.warning,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              l10n.parkingUpdateRequiresApproval,
                              style: AppTextStyles.bodySmall(
                                context,
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
