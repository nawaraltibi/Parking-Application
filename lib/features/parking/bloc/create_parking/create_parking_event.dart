part of 'create_parking_bloc.dart';

/// Base class for create parking events
abstract class CreateParkingEvent extends Equatable {
  const CreateParkingEvent();

  @override
  List<Object?> get props => [];
}

/// Update lot name in the parking request
class UpdateLotName extends CreateParkingEvent {
  final String lotName;

  const UpdateLotName(this.lotName);

  @override
  List<Object?> get props => [lotName];
}

/// Update address in the parking request
class UpdateAddress extends CreateParkingEvent {
  final String address;

  const UpdateAddress(this.address);

  @override
  List<Object?> get props => [address];
}

/// Update hourly rate in the parking request
class UpdateHourlyRate extends CreateParkingEvent {
  final double rate;

  const UpdateHourlyRate(this.rate);

  @override
  List<Object?> get props => [rate];
}

/// Update total spaces in the parking request
class UpdateTotalSpaces extends CreateParkingEvent {
  final int totalSpaces;

  const UpdateTotalSpaces(this.totalSpaces);

  @override
  List<Object?> get props => [totalSpaces];
}

/// Update coordinates in the parking request
class UpdateCoordinates extends CreateParkingEvent {
  final double latitude;
  final double longitude;

  const UpdateCoordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Submit create parking request
class SubmitCreateParking extends CreateParkingEvent {
  final CreateParkingRequest request;

  const SubmitCreateParking(this.request);

  @override
  List<Object?> get props => [request];
}

/// Reset state to initial
class ResetCreateParkingState extends CreateParkingEvent {
  const ResetCreateParkingState();
}

