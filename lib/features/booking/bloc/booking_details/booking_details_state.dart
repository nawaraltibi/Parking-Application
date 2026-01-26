part of 'booking_details_bloc.dart';

/// Base class for booking details states
abstract class BookingDetailsState extends Equatable {
  const BookingDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BookingDetailsInitial extends BookingDetailsState {
  const BookingDetailsInitial();
}

/// Loading booking details
class BookingDetailsLoading extends BookingDetailsState {
  final int bookingId;

  const BookingDetailsLoading({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

/// Booking details loaded
class BookingDetailsLoaded extends BookingDetailsState {
  final int bookingId;
  final BookingDetailsResponse response;

  const BookingDetailsLoaded({
    required this.bookingId,
    required this.response,
  });

  @override
  List<Object?> get props => [bookingId, response];
}

/// Loading remaining time
class RemainingTimeLoading extends BookingDetailsState {
  final int bookingId;

  const RemainingTimeLoading({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

/// Remaining time loaded
class RemainingTimeLoaded extends BookingDetailsState {
  final int bookingId;
  final RemainingTimeResponse response;

  const RemainingTimeLoaded({
    required this.bookingId,
    required this.response,
  });

  @override
  List<Object?> get props => [bookingId, response];

  /// Check if there's a warning (< 10 minutes)
  bool get hasWarning => response.hasWarning;

  /// Check if time has expired
  bool get hasExpired => response.hasExpired;
}

/// Booking details error
class BookingDetailsError extends BookingDetailsState {
  final int bookingId;
  final String message;
  final int? statusCode;
  final String? errorCode;

  const BookingDetailsError({
    required this.bookingId,
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  List<Object?> get props => [bookingId, message, statusCode, errorCode];
}

