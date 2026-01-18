part of 'login_cubit.dart';

/// Login State
/// Represents different states of the login process
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no login attempt yet
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Loading state - login request in progress
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Success state - login completed successfully
class LoginSuccess extends LoginState {
  final LoginResponse response;
  final String message;

  const LoginSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state - login failed
class LoginError extends LoginState {
  final String error;
  final int statusCode;
  final bool isInactiveUser;
  final String? userType;

  const LoginError({
    required this.error,
    required this.statusCode,
    this.isInactiveUser = false,
    this.userType,
  });

  @override
  List<Object?> get props => [error, statusCode, isInactiveUser, userType];
}

