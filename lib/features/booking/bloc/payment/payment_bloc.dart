import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/payment_request.dart';
import '../../models/payment_response.dart';
import '../../models/payments_list_response.dart';
import '../../repository/booking_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

/// Payment BLoC
/// Manages payment processing and payment history
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentInitial()) {
    on<ProcessPaymentSuccess>(_onProcessPaymentSuccess);
    on<ProcessPaymentFailure>(_onProcessPaymentFailure);
    on<LoadPaymentHistory>(_onLoadPaymentHistory);
    on<ResetPaymentState>(_onResetState);
  }

  /// Process successful payment
  Future<void> _onProcessPaymentSuccess(
    ProcessPaymentSuccess event,
    Emitter<PaymentState> emit,
  ) async {
    // Validate amount
    if (event.amount <= 0) {
      emit(PaymentError(
        message: 'invalid_amount',
        bookingId: event.bookingId,
      ));
      return;
    }

    emit(PaymentProcessing(
      bookingId: event.bookingId,
      isSuccess: true,
    ));

    try {
      final request = PaymentRequest(
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        transactionId: event.transactionId,
      );

      final response = await BookingRepository.processPaymentSuccess(
        bookingId: event.bookingId,
        request: request,
      );

      if (!emit.isDone) {
        emit(PaymentProcessed(
          bookingId: event.bookingId,
          response: response,
          wasSuccessful: true,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(PaymentError(
          message: e.message,
          bookingId: event.bookingId,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(PaymentError(
          message: e.toString(),
          bookingId: event.bookingId,
        ));
      }
    }
  }

  /// Process failed payment
  Future<void> _onProcessPaymentFailure(
    ProcessPaymentFailure event,
    Emitter<PaymentState> emit,
  ) async {
    emit(PaymentProcessing(
      bookingId: event.bookingId,
      isSuccess: false,
    ));

    try {
      final request = PaymentRequest(
        amount: event.amount,
        paymentMethod: event.paymentMethod,
        transactionId: event.transactionId,
      );

      final response = await BookingRepository.processPaymentFailure(
        bookingId: event.bookingId,
        request: request,
      );

      if (!emit.isDone) {
        emit(PaymentProcessed(
          bookingId: event.bookingId,
          response: response,
          wasSuccessful: false,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(PaymentError(
          message: e.message,
          bookingId: event.bookingId,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(PaymentError(
          message: e.toString(),
          bookingId: event.bookingId,
        ));
      }
    }
  }

  /// Load payment history
  Future<void> _onLoadPaymentHistory(
    LoadPaymentHistory event,
    Emitter<PaymentState> emit,
  ) async {
    // Avoid multiple concurrent loads
    if (state is PaymentHistoryLoading) return;

    emit(const PaymentHistoryLoading());

    try {
      final response = await BookingRepository.getPaymentHistory();

      if (!emit.isDone) {
        emit(PaymentHistoryLoaded(response: response));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(PaymentError(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(PaymentError(message: e.toString()));
      }
    }
  }

  /// Reset state to initial
  void _onResetState(
    ResetPaymentState event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }
}

