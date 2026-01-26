part of 'booking_details_bloc.dart';

/// Base class for booking details events
abstract class BookingDetailsEvent extends Equatable {
  const BookingDetailsEvent();

  @override
  List<Object?> get props => [];
}

/// Load booking details
class LoadBookingDetails extends BookingDetailsEvent {
  final int bookingId;

  const LoadBookingDetails({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

/// Load remaining time for a booking
class LoadRemainingTime extends BookingDetailsEvent {
  final int bookingId;

  const LoadRemainingTime({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

/// Refresh current booking details
class RefreshBookingDetails extends BookingDetailsEvent {
  const RefreshBookingDetails();
}

/// Start real-time remaining time updates
class StartRemainingTimeTimer extends BookingDetailsEvent {
  final int bookingId;

  const StartRemainingTimeTimer({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

/// Stop real-time remaining time updates
class StopRemainingTimeTimer extends BookingDetailsEvent {
  const StopRemainingTimeTimer();
}

/// Remaining time tick event (dispatched periodically)
class RemainingTimeTicked extends BookingDetailsEvent {
  final int bookingId;

  const RemainingTimeTicked({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

