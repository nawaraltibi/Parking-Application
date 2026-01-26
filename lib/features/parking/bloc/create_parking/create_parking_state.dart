part of 'create_parking_bloc.dart';

/// Base class for create parking states
abstract class CreateParkingState extends Equatable {
  final CreateParkingRequest request;

  const CreateParkingState({required this.request});

  @override
  List<Object?> get props => [request];
}

/// Initial state with empty/default request
class CreateParkingInitial extends CreateParkingState {
  const CreateParkingInitial({required super.request});
}

/// Loading state while creating parking
class CreateParkingLoading extends CreateParkingState {
  const CreateParkingLoading({required super.request});
}

/// Success state after parking created
class CreateParkingSuccess extends CreateParkingState {
  final CreateParkingResponse response;

  const CreateParkingSuccess({
    required super.request,
    required this.response,
  });

  @override
  List<Object?> get props => [request, response];
}

/// Failure state with error details
class CreateParkingFailure extends CreateParkingState {
  final String error;
  final int? statusCode;
  final String? errorCode;
  final Map<String, List<String>>? validationErrors;

  const CreateParkingFailure({
    required super.request,
    required this.error,
    this.statusCode,
    this.errorCode,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [
        request,
        error,
        statusCode,
        errorCode,
        validationErrors,
      ];
}

