part of 'booking_action_bloc.dart';

/// Base class for booking action events
abstract class BookingActionEvent extends Equatable {
  const BookingActionEvent();

  @override
  List<Object?> get props => [];
}

/// Cancel a booking
class CancelBooking extends BookingActionEvent {
  final int bookingId;

  const CancelBooking({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

/// Extend a booking
class ExtendBooking extends BookingActionEvent {
  final int bookingId;
  final int extraHours;

  const ExtendBooking({
    required this.bookingId,
    required this.extraHours,
  });

  @override
  List<Object?> get props => [bookingId, extraHours];
}

/// Reset state to initial
class ResetBookingActionState extends BookingActionEvent {
  const ResetBookingActionState();
}

