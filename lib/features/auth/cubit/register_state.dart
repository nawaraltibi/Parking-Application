part of 'register_cubit.dart';

/// Register State
/// Represents different states of the registration process
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no registration attempt yet
class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

/// Loading state - registration request in progress
class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

/// Success state - registration completed successfully
class RegisterSuccess extends RegisterState {
  final RegisterResponse response;
  final String message;

  const RegisterSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state - registration failed
class RegisterError extends RegisterState {
  final String error;
  final int statusCode;

  const RegisterError({
    required this.error,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [error, statusCode];
}

