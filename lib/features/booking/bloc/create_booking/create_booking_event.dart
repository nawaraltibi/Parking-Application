part of 'create_booking_bloc.dart';

/// Base class for create booking events
abstract class CreateBookingEvent extends Equatable {
  const CreateBookingEvent();

  @override
  List<Object?> get props => [];
}

/// Update lot ID in the booking request
class UpdateLotId extends CreateBookingEvent {
  final int lotId;

  const UpdateLotId(this.lotId);

  @override
  List<Object?> get props => [lotId];
}

/// Update vehicle ID in the booking request
class UpdateVehicleId extends CreateBookingEvent {
  final int vehicleId;

  const UpdateVehicleId(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}

/// Update hours in the booking request
class UpdateHours extends CreateBookingEvent {
  final int hours;

  const UpdateHours(this.hours);

  @override
  List<Object?> get props => [hours];
}

/// Submit create booking request
class SubmitCreateBooking extends CreateBookingEvent {
  const SubmitCreateBooking();
}

/// Reset state to initial
class ResetCreateBookingState extends CreateBookingEvent {
  const ResetCreateBookingState();
}

