import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../repository/auth_repository.dart';
import '../../../core/utils/app_exception.dart';

part 'register_state.dart';

/// Register Cubit
/// Manages registration state and business logic
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  /// Register a new user
  Future<void> register(RegisterRequest request) async {
    // Validate request locally first
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      emit(RegisterError(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(RegisterLoading());

    try {
      final response = await AuthRepository.register(registerRequest: request);
      
      emit(RegisterSuccess(
        response: response,
        message: response.message,
      ));
    } on AppException catch (e) {
      // Handle API errors (422 validation, 500 server errors, etc.)
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
      
      emit(RegisterError(
        error: errorMessage,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      // Handle unexpected errors
      emit(RegisterError(
        error: 'An unexpected error occurred. Please try again.',
        statusCode: 500,
      ));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(RegisterInitial());
  }
}

