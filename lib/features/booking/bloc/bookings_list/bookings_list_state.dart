part of 'bookings_list_bloc.dart';

/// Base class for bookings list states
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
  final bool isActive; // true for active bookings, false for finished

  const BookingsListLoading({required this.isActive});

  @override
  List<Object?> get props => [isActive];
}

/// Loaded state with bookings data
class BookingsListLoaded extends BookingsListState {
  final BookingsListResponse response;
  final bool isActive; // true for active bookings, false for finished

  const BookingsListLoaded({
    required this.response,
    required this.isActive,
  });

  @override
  List<Object?> get props => [response, isActive];

  /// Check if list is empty
  bool get isEmpty => !response.hasBookings;

  /// Get bookings count
  int get count => response.bookingsCount;
}

/// Error state
class BookingsListError extends BookingsListState {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final bool isActive; // true for active bookings, false for finished

  const BookingsListError({
    required this.message,
    this.statusCode,
    this.errorCode,
    required this.isActive,
  });

  @override
  List<Object?> get props => [message, statusCode, errorCode, isActive];
}

