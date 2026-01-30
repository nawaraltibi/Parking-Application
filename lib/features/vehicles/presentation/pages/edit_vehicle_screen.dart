import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/services/vehicles_list_refresh_notifier.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../bloc/vehicles_bloc.dart';
import '../utils/vehicles_error_handler.dart';
import '../utils/vehicle_constants.dart';
import '../utils/color_name_mapper.dart';
import '../widgets/vehicle_form_fields.dart';

/// Edit Vehicle Screen (User side)
/// Note: Updates create a modification request requiring admin approval.
class EditVehicleScreen extends StatefulWidget {
  final VehicleEntity vehicle;

  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _plateController;
  late final TextEditingController _typeController;
  late final TextEditingController _otherCarMakeController;

  String? _selectedCarMake;
  Color? _selectedColor;

  @override
  void initState() {
    super.initState();
    _plateController = TextEditingController(text: widget.vehicle.platNumber);
    _typeController = TextEditingController(text: widget.vehicle.carModel);
    _otherCarMakeController = TextEditingController();

    // Initialize car make: check if it's in the list, otherwise use "Other"
    final carMake = widget.vehicle.carMake;
    if (VehicleConstants.carMakes.contains(carMake)) {
      _selectedCarMake = carMake;
    } else {
      _selectedCarMake = VehicleConstants.otherCarMake;
      _otherCarMakeController.text = carMake;
    }

    // Initialize color: convert color name to Color object
    final colorName = widget.vehicle.color;
    _selectedColor = ColorNameMapper.mapNameToColor(colorName);
  }

  @override
  void dispose() {
    _plateController.dispose();
    _typeController.dispose();
    _otherCarMakeController.dispose();
    super.dispose();
  }

  void _submit() {
    // Validate dropdowns first
    if (_selectedCarMake == null || _selectedCarMake!.isEmpty) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        UnifiedSnackbar.error(
          context,
          message:
              '${l10n.vehiclesFormNameLabel} ${l10n.vehiclesErrorValidation.toLowerCase()}',
        );
      }
      return;
    }

    // Validate "Other" car make input if selected
    if (_selectedCarMake == 'Other') {
      if (_otherCarMakeController.text.trim().isEmpty) {
        final l10n = AppLocalizations.of(context);
        if (l10n != null) {
          UnifiedSnackbar.error(context, message: l10n.vehiclesErrorValidation);
        }
        return;
      }
    }

    if (_selectedColor == null) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        UnifiedSnackbar.error(
          context,
          message:
              '${l10n.vehiclesFormColorLabel} ${l10n.vehiclesErrorValidation.toLowerCase()}',
        );
      }
      return;
    }

    // Validate text fields
    if (!_formKey.currentState!.validate()) return;

    // Determine car make: use "Other" input if selected, otherwise use dropdown value
    final carMake = _selectedCarMake == 'Other'
        ? _otherCarMakeController.text.trim()
        : _selectedCarMake!;

    // Convert Color to color name
    final colorName = ColorNameMapper.mapColorToName(_selectedColor!);

    context.read<VehiclesBloc>().add(
      UpdateVehicleRequested(
        vehicleId: widget.vehicle.vehicleId,
        platNumber: _plateController.text.trim(),
        carMake: carMake,
        carModel: _typeController.text.trim(),
        color: colorName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.vehiclesEditTitle,
          style: AppTextStyles.titleLarge(context),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<VehiclesBloc, VehiclesState>(
          listenWhen: (previous, current) =>
              current is VehicleActionSuccess ||
              current is VehicleActionFailure,
          listener: (context, state) {
            if (state is VehicleActionSuccess) {
              UnifiedSnackbar.success(
                context,
                message: l10n.vehiclesSuccessUpdateRequested,
              );
              context.read<VehiclesBloc>().add(ResetVehiclesState());
              getIt<VehiclesListRefreshNotifier>().requestRefresh();
              Future.delayed(const Duration(milliseconds: 350), () {
                if (context.mounted) {
                  context.pop();
                }
              });
            } else if (state is VehicleActionFailure) {
              // 422 should be shown inline; other errors as snackbar
              if (state.statusCode != 422) {
                final errorMessage = VehiclesErrorHandler.handleErrorState(
                  state.error,
                  state.statusCode,
                  l10n,
                );
                UnifiedSnackbar.error(context, message: errorMessage);
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is VehicleActionLoading;
            final inlineError =
                state is VehicleActionFailure && state.statusCode == 422
                ? VehiclesErrorHandler.handleErrorState(
                    state.error,
                    state.statusCode,
                    l10n,
                  )
                : null;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 24.w,
                end: 24.w,
                top: 20.h,
                bottom: 20.h,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsetsDirectional.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.warning.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.warning.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            EvaIcons.infoOutline,
                            size: 20.sp,
                            color: AppColors.warning,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              l10n.vehiclesUpdateRequiresApproval,
                              style: AppTextStyles.bodySmall(
                                context,
                                color: AppColors.warning,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    if (inlineError != null) ...[
                      Container(
                        padding: EdgeInsetsDirectional.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              EvaIcons.alertCircleOutline,
                              size: 20.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                inlineError,
                                style: AppTextStyles.bodySmall(
                                  context,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                    VehicleFormFields(
                      selectedCarMake: _selectedCarMake,
                      onCarMakeChanged: (value) {
                        setState(() {
                          _selectedCarMake = value;
                          if (value != 'Other') {
                            _otherCarMakeController.clear();
                          }
                        });
                      },
                      otherCarMakeController: _otherCarMakeController,
                      plateController: _plateController,
                      typeController: _typeController,
                      selectedColor: _selectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      enabled: !isLoading,
                    ),
                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      title: l10n.vehiclesSaveButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _submit,
                    ),
                    SizedBox(height: 16.h),
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
