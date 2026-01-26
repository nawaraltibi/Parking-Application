part of 'bookings_list_bloc.dart';

/// Base class for bookings list events
abstract class BookingsListEvent extends Equatable {
  const BookingsListEvent();

  @override
  List<Object?> get props => [];
}

/// Load active bookings (active + pending, not expired)
class LoadActiveBookings extends BookingsListEvent {
  const LoadActiveBookings();
}

/// Load finished bookings (inactive or expired)
class LoadFinishedBookings extends BookingsListEvent {
  const LoadFinishedBookings();
}

/// Refresh current bookings list
class RefreshBookings extends BookingsListEvent {
  const RefreshBookings();
}

