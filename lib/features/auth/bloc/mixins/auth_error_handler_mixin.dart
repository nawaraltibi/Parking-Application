import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/login_request.dart';
import '../../models/register_request.dart';
import '../login/login_bloc.dart';
import '../register/register_bloc.dart';
import '../logout/logout_bloc.dart';

/// Mixin for handling errors in auth blocs
/// Note: This mixin must be used with a Bloc that has auth states
mixin AuthErrorHandlerMixin {
  /// Handle error and emit failure state for login
  void handleLoginError(
    Object error,
    Emitter<LoginState> emit,
    LoginRequest request,
  ) {
    String errorMessage = '';
    int statusCode = 500;
    bool isInactiveUser = false;
    String? userType;

    if (error is AppException) {
      errorMessage = error.message;
      statusCode = error.statusCode;
      
      // Handle validation errors
      if (error.errors != null && error.errors!.isNotEmpty) {
        final errorList = <String>[];
        error.errors!.forEach((key, value) {
          errorList.addAll(value);
        });
        if (errorList.isNotEmpty) {
          errorMessage = errorList.join('\n');
        }
      }
      
      // Handle owner pending approval (403)
      if (error.statusCode == 403 && error.errorCode == 'owner_pending_approval') {
        isInactiveUser = true;
        userType = 'owner';
      }
    } else {
      errorMessage = error.toString();
    }

    emit(LoginFailure(
      request: request,
      error: errorMessage,
      statusCode: statusCode,
      isInactiveUser: isInactiveUser,
      userType: userType,
    ));
  }
  
  /// Handle error and emit failure state for register
  void handleRegisterError(
    Object error,
    Emitter<RegisterState> emit,
    RegisterRequest request,
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

    emit(RegisterFailure(
      request: request,
      error: errorMessage,
      statusCode: statusCode,
    ));
  }
  
  /// Handle error and emit failure state for logout
  void handleLogoutError(
    Object error,
    Emitter<LogoutState> emit,
  ) {
    String errorMessage = '';
    int statusCode = 500;

    if (error is AppException) {
      errorMessage = error.message;
      statusCode = error.statusCode;
    } else {
      errorMessage = error.toString();
    }

    emit(LogoutFailure(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }
}

