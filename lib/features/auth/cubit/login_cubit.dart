import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../repository/auth_repository.dart';
import '../../../core/utils/app_exception.dart';
import '../../../data/repositories/auth_local_repository.dart';

part 'login_state.dart';

/// Login Cubit
/// Manages login state and business logic
class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  /// Login user
  Future<void> login(LoginRequest request) async {
    // Validate request locally first
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      emit(LoginError(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(LoginLoading());

    try {
      final response = await AuthRepository.login(loginRequest: request);
      
      // Check user status and handle inactive users
      final statusMessage = response.getStatusMessage();
      if (statusMessage != null) {
        // User is inactive - show appropriate message
        emit(LoginError(
          error: statusMessage,
          statusCode: 403, // Forbidden - account not active
          isInactiveUser: true,
          userType: response.userType,
        ));
        return;
      }
      
      // User is active - save token and user data
      await AuthLocalRepository.saveToken(response.token);
      await AuthLocalRepository.saveUser(response.user.toJson());
      
      emit(LoginSuccess(
        response: response,
        message: response.message,
      ));
    } on AppException catch (e) {
      // Handle API errors (401 invalid credentials, 422 validation, 500 server errors, etc.)
      String errorMessage = e.message;
      
      // Extract validation errors if available
      if (e.errors != null && e.errors!.isNotEmpty) {
        final errorList = <String>[];
        e.errors!.forEach((key, value) {
          errorList.addAll(value);
        });
        if (errorList.isNotEmpty) {
          errorMessage = errorList.join('\n');
        }
      }
      
      // Handle 401 specifically (Invalid Email or Password)
      if (e.statusCode == 401) {
        errorMessage = 'Invalid Email or Password';
      }
      
      emit(LoginError(
        error: errorMessage,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      // Handle unexpected errors
      emit(LoginError(
        error: 'An unexpected error occurred. Please try again.',
        statusCode: 500,
      ));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(LoginInitial());
  }
}

