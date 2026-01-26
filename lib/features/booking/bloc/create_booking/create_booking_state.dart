part of 'create_booking_bloc.dart';

/// Base class for create booking states
abstract class CreateBookingState extends Equatable {
  final CreateBookingRequest request;

  const CreateBookingState({required this.request});

  @override
  List<Object?> get props => [request];
}

/// Initial state with empty/default request
class CreateBookingInitial extends CreateBookingState {
  const CreateBookingInitial({required super.request});
}

/// Loading state while creating booking
class CreateBookingLoading extends CreateBookingState {
  const CreateBookingLoading({required super.request});
}

/// Success state after booking created
class CreateBookingSuccess extends CreateBookingState {
  final CreateBookingResponse response;

  const CreateBookingSuccess({
    required super.request,
    required this.response,
  });

  @override
  List<Object?> get props => [request, response];
}

/// Failure state with error details
class CreateBookingFailure extends CreateBookingState {
  final String error;
  final int? statusCode;
  final String? errorCode;
  final Map<String, List<String>>? validationErrors;
  final Map<String, dynamic>? responseData; // For special cases like 409 with booking_id

  const CreateBookingFailure({
    required super.request,
    required this.error,
    this.statusCode,
    this.errorCode,
    this.validationErrors,
    this.responseData,
  });

  @override
  List<Object?> get props => [
        request,
        error,
        statusCode,
        errorCode,
        validationErrors,
        responseData,
      ];
}

