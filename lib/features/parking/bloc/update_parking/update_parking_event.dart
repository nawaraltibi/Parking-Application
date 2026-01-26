part of 'update_parking_bloc.dart';

/// Base class for update parking events
abstract class UpdateParkingEvent extends Equatable {
  const UpdateParkingEvent();

  @override
  List<Object?> get props => [];
}

/// Load parking data for editing
class LoadParkingForEdit extends UpdateParkingEvent {
  final int parkingId;
  final UpdateParkingRequest initialData;

  const LoadParkingForEdit({
    required this.parkingId,
    required this.initialData,
  });

  @override
  List<Object?> get props => [parkingId, initialData];
}

/// Update a field in the parking request
class UpdateParkingField extends UpdateParkingEvent {
  final UpdateParkingRequest Function(UpdateParkingRequest) updateRequest;

  const UpdateParkingField(this.updateRequest);

  @override
  List<Object?> get props => [updateRequest];
}

/// Submit update parking request
class SubmitUpdateParking extends UpdateParkingEvent {
  final int parkingId;
  final UpdateParkingRequest request;

  const SubmitUpdateParking({
    required this.parkingId,
    required this.request,
  });

  @override
  List<Object?> get props => [parkingId, request];
}

/// Reset state to initial
class ResetUpdateParkingState extends UpdateParkingEvent {
  const ResetUpdateParkingState();
}

