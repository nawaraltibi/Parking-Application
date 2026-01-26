part of 'payment_bloc.dart';

/// Base class for payment states
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Processing payment
class PaymentProcessing extends PaymentState {
  final int bookingId;
  final bool isSuccess; // true for success, false for failure

  const PaymentProcessing({
    required this.bookingId,
    required this.isSuccess,
  });

  @override
  List<Object?> get props => [bookingId, isSuccess];
}

/// Payment processed (success or failure recorded)
class PaymentProcessed extends PaymentState {
  final int bookingId;
  final PaymentResponse response;
  final bool wasSuccessful; // true if payment succeeded, false if failed

  const PaymentProcessed({
    required this.bookingId,
    required this.response,
    required this.wasSuccessful,
  });

  @override
  List<Object?> get props => [bookingId, response, wasSuccessful];
}

/// Loading payment history
class PaymentHistoryLoading extends PaymentState {
  const PaymentHistoryLoading();
}

/// Payment history loaded
class PaymentHistoryLoaded extends PaymentState {
  final PaymentsListResponse response;

  const PaymentHistoryLoaded({required this.response});

  @override
  List<Object?> get props => [response];

  /// Check if history is empty
  bool get isEmpty => !response.hasPayments;

  /// Get payments count
  int get count => response.paymentsCount;
}

/// Payment error
class PaymentError extends PaymentState {
  final String message;
  final int? bookingId;
  final int? statusCode;
  final String? errorCode;

  const PaymentError({
    required this.message,
    this.bookingId,
    this.statusCode,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, bookingId, statusCode, errorCode];
}

