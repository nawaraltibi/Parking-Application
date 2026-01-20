import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../parking_cubit.dart';

/// Mixin for handling errors in parking cubit
/// Note: This mixin must be used with a Cubit<ParkingState>
mixin ParkingErrorHandlerMixin on Cubit<ParkingState> {
  /// Handle error and emit failure state
  void handleError(Object error, {bool isDashboard = false}) {
    String errorMessage = '';
    int statusCode = 500;

    if (error is AppException) {
      errorMessage = error.message;
      statusCode = error.statusCode;

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

    if (isDashboard) {
      emit(DashboardFailure(
        error: errorMessage,
        statusCode: statusCode,
      ));
    } else {
      emit(ParkingFailure(
        error: errorMessage,
        statusCode: statusCode,
      ));
    }
  }
}

