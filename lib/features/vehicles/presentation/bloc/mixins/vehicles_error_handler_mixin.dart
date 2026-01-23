import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_exception.dart';
import '../vehicles_bloc.dart';

/// Mixin for handling errors in vehicles bloc
/// Note: This mixin must be used with a Bloc<VehiclesEvent, VehiclesState>
mixin VehiclesErrorHandlerMixin on Bloc<VehiclesEvent, VehiclesState> {
  /// Handle error and emit failure state for get vehicles
  void handleError(
    Object error,
    Emitter<VehiclesState> emit,
  ) {
    String errorMessage = '';
    int statusCode = 500;

    if (error is AppException) {
      errorMessage = error.message;
      statusCode = error.statusCode;

      // Extract validation errors if available
      if (error.errors != null && error.errors!.isNotEmpty) {
        final errorList = <String>[];
        error.errors!.forEach((key, value) {
          errorList.addAll(value);
        });
        if (errorList.isNotEmpty) {
          errorMessage = errorList.join('\n');
        }
      }
    } else {
      errorMessage = error.toString();
    }

    emit(VehiclesError(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }

  /// Handle error and emit failure state for vehicle actions (add, update, delete)
  void handleVehicleActionError(
    Object error,
    Emitter<VehiclesState> emit,
  ) {
    String errorMessage = '';
    int statusCode = 500;

    if (error is AppException) {
      errorMessage = error.message;
      statusCode = error.statusCode;

      // Extract validation errors if available
      if (error.errors != null && error.errors!.isNotEmpty) {
        final errorList = <String>[];
        error.errors!.forEach((key, value) {
          errorList.addAll(value);
        });
        if (errorList.isNotEmpty) {
          errorMessage = errorList.join('\n');
        }
      }
    } else {
      errorMessage = error.toString();
    }

    emit(VehicleActionFailure(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }
}

