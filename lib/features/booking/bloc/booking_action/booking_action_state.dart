part of 'booking_action_bloc.dart';

/// Type of booking action
enum BookingActionType {
  cancel,
  extend,
}

/// Base class for booking action states
abstract class BookingActionState extends Equatable {
  const BookingActionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BookingActionInitial extends BookingActionState {
  const BookingActionInitial();
}

/// Loading state while performing action
class BookingActionLoading extends BookingActionState {
  final int bookingId;
  final BookingActionType action;

  const BookingActionLoading({
    required this.bookingId,
    required this.action,
  });

  @override
  List<Object?> get props => [bookingId, action];
}

/// Success state after action completed
class BookingActionSuccess extends BookingActionState {
  final int bookingId;
  final BookingActionType action;
  final String message;

  const BookingActionSuccess({
    required this.bookingId,
    required this.action,
    required this.message,
  });

  @override
  List<Object?> get props => [bookingId, action, message];
}

/// Failure state with error details
class BookingActionFailure extends BookingActionState {
  final int bookingId;
  final BookingActionType action;
  final String error;
  final int? statusCode;
  final String? errorCode;

  const BookingActionFailure({
    required this.bookingId,
    required this.action,
    required this.error,
    this.statusCode,
    this.errorCode,
  });

  @override
  List<Object?> get props => [bookingId, action, error, statusCode, errorCode];
}

