part of 'bookings_list_bloc.dart';

/// Bookings List Events
abstract class BookingsListEvent extends Equatable {
  const BookingsListEvent();

  @override
  List<Object?> get props => [];
}

/// Load active bookings
class LoadActiveBookings extends BookingsListEvent {
  const LoadActiveBookings();
}

/// Load finished bookings
class LoadFinishedBookings extends BookingsListEvent {
  const LoadFinishedBookings();
}

/// Refresh bookings (reload current tab)
class RefreshBookings extends BookingsListEvent {
  const RefreshBookings();
}

/// Switch between active and finished tabs
class SwitchTab extends BookingsListEvent {
  final bool isActiveTab;

  const SwitchTab({required this.isActiveTab});

  @override
  List<Object?> get props => [isActiveTab];
}
