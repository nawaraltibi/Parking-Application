import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/enums/loading_type.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/vehicles_bloc.dart';
import '../utils/vehicles_error_handler.dart';

/// Delete Vehicle Confirmation Dialog (Material 3)
class DeleteVehicleDialog extends StatelessWidget {
  final int vehicleId;
  final String plateNumber;

  const DeleteVehicleDialog({
    super.key,
    required this.vehicleId,
    required this.plateNumber,
  });

  static Future<void> show(
    BuildContext context, {
    required int vehicleId,
    required String plateNumber,
  }) async {
    final vehiclesBloc = context.read<VehiclesBloc>();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: vehiclesBloc,
        child: DeleteVehicleDialog(
          vehicleId: vehicleId,
          plateNumber: plateNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocConsumer<VehiclesBloc, VehiclesState>(
      listenWhen: (previous, current) =>
          current is VehicleActionSuccess || current is VehicleActionFailure,
      listener: (context, state) {
        if (state is VehicleActionSuccess) {
          Navigator.of(context).pop();
          UnifiedSnackbar.success(context, message: l10n.vehiclesSuccessDeleted);
          context.read<VehiclesBloc>().add(ResetVehiclesState());
        } else if (state is VehicleActionFailure) {
          final errorMessage = VehiclesErrorHandler.handleErrorState(
            state.error,
            state.statusCode,
            l10n,
          );
          UnifiedSnackbar.error(context, message: errorMessage);
        }
      },
      builder: (context, state) {
        final isLoading = state is VehicleActionLoading;

        return AlertDialog(
          title: Text(l10n.vehiclesDeleteDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.vehiclesDeleteDialogMessage),
              SizedBox(height: 8.h),
              Text(
                plateNumber,
                style: AppTextStyles.labelSmall(
                  context,
                  color: AppColors.secondaryText,
                ),
              ),
              if (isLoading) ...[
                SizedBox(height: 16.h),
                const LoadingWidget(type: LoadingType.small, withPadding: false),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
              child: Text(l10n.profileCancelButton),
            ),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      context
                          .read<VehiclesBloc>()
                          .add(DeleteVehicleRequested(vehicleId: vehicleId));
                    },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: Text(l10n.profileDeleteAccountDialogConfirm),
            ),
          ],
        );
      },
    );
  }
}


