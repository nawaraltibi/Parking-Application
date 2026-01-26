part of 'update_parking_bloc.dart';

/// Base class for update parking states
abstract class UpdateParkingState extends Equatable {
  const UpdateParkingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class UpdateParkingInitial extends UpdateParkingState {
  const UpdateParkingInitial();
}

/// Editing state with parking data
class UpdateParkingEditing extends UpdateParkingState {
  final int parkingId;
  final UpdateParkingRequest request;

  const UpdateParkingEditing({
    required this.parkingId,
    required this.request,
  });

  @override
  List<Object?> get props => [parkingId, request];
}

/// Loading state while updating parking
class UpdateParkingLoading extends UpdateParkingState {
  final int parkingId;
  final UpdateParkingRequest request;

  const UpdateParkingLoading({
    required this.parkingId,
    required this.request,
  });

  @override
  List<Object?> get props => [parkingId, request];
}

/// Success state after parking updated
class UpdateParkingSuccess extends UpdateParkingState {
  final int parkingId;
  final UpdateParkingRequest request;
  final UpdateParkingResponse response;

  const UpdateParkingSuccess({
    required this.parkingId,
    required this.request,
    required this.response,
  });

  @override
  List<Object?> get props => [parkingId, request, response];
}

/// Failure state with error details
class UpdateParkingFailure extends UpdateParkingState {
  final int parkingId;
  final UpdateParkingRequest request;
  final String error;
  final int? statusCode;
  final String? errorCode;
  final Map<String, List<String>>? validationErrors;

  const UpdateParkingFailure({
    required this.parkingId,
    required this.request,
    required this.error,
    this.statusCode,
    this.errorCode,
    this.validationErrors,
  });

  @override
  List<Object?> get props => [
        parkingId,
        request,
        error,
        statusCode,
        errorCode,
        validationErrors,
      ];
}

