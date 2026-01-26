part of 'bookings_list_bloc.dart';

/// Bookings List States
abstract class BookingsListState extends Equatable {
  const BookingsListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BookingsListInitial extends BookingsListState {
  const BookingsListInitial();
}

/// Loading state
class BookingsListLoading extends BookingsListState {
  const BookingsListLoading();
}

/// Loaded state with bookings
class BookingsListLoaded extends BookingsListState {
  final List<BookingModel> bookings;
  final bool isActiveTab;

  const BookingsListLoaded({
    required this.bookings,
    required this.isActiveTab,
  });

  @override
  List<Object?> get props => [bookings, isActiveTab];

  bool get hasBookings => bookings.isNotEmpty;
}

/// Error state
class BookingsListError extends BookingsListState {
  final String message;

  const BookingsListError({required this.message});

  @override
  List<Object?> get props => [message];
}
