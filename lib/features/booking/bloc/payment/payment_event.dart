part of 'payment_bloc.dart';

/// Base class for payment events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Process successful payment
class ProcessPaymentSuccess extends PaymentEvent {
  final int bookingId;
  final double amount;
  final String paymentMethod;
  final String? transactionId;

  const ProcessPaymentSuccess({
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.transactionId,
  });

  @override
  List<Object?> get props => [bookingId, amount, paymentMethod, transactionId];
}

/// Process failed payment
class ProcessPaymentFailure extends PaymentEvent {
  final int bookingId;
  final double amount;
  final String paymentMethod;
  final String? transactionId;

  const ProcessPaymentFailure({
    required this.bookingId,
    required this.amount,
    required this.paymentMethod,
    this.transactionId,
  });

  @override
  List<Object?> get props => [bookingId, amount, paymentMethod, transactionId];
}

/// Load payment history
class LoadPaymentHistory extends PaymentEvent {
  const LoadPaymentHistory();
}

/// Reset state to initial
class ResetPaymentState extends PaymentEvent {
  const ResetPaymentState();
}

