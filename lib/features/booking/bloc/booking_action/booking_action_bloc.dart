import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/extend_booking_request.dart';
import '../../repository/booking_repository.dart';

part 'booking_action_event.dart';
part 'booking_action_state.dart';

/// Booking Action BLoC
/// Handles booking actions: cancel, extend
/// Dedicated BLoC for booking modification operations
class BookingActionBloc extends Bloc<BookingActionEvent, BookingActionState> {
  BookingActionBloc() : super(const BookingActionInitial()) {
    on<CancelBooking>(_onCancelBooking);
    on<ExtendBooking>(_onExtendBooking);
    on<ResetBookingActionState>(_onResetState);
  }

  /// Cancel a booking
  Future<void> _onCancelBooking(
    CancelBooking event,
    Emitter<BookingActionState> emit,
  ) async {
    emit(BookingActionLoading(
      bookingId: event.bookingId,
      action: BookingActionType.cancel,
    ));

    try {
      final response = await BookingRepository.cancelBooking(
        bookingId: event.bookingId,
      );

      if (!emit.isDone) {
        emit(BookingActionSuccess(
          bookingId: event.bookingId,
          action: BookingActionType.cancel,
          message: response.message,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingActionFailure(
          bookingId: event.bookingId,
          action: BookingActionType.cancel,
          error: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingActionFailure(
          bookingId: event.bookingId,
          action: BookingActionType.cancel,
          error: e.toString(),
        ));
      }
    }
  }

  /// Extend a booking
  Future<void> _onExtendBooking(
    ExtendBooking event,
    Emitter<BookingActionState> emit,
  ) async {
    // Validate extra hours
    if (event.extraHours < 1) {
      emit(BookingActionFailure(
        bookingId: event.bookingId,
        action: BookingActionType.extend,
        error: 'invalid_hours',
      ));
      return;
    }

    emit(BookingActionLoading(
      bookingId: event.bookingId,
      action: BookingActionType.extend,
    ));

    try {
      final request = ExtendBookingRequest(extraHours: event.extraHours);
      final response = await BookingRepository.extendBooking(
        bookingId: event.bookingId,
        request: request,
      );

      if (!emit.isDone) {
        emit(BookingActionSuccess(
          bookingId: event.bookingId,
          action: BookingActionType.extend,
          message: response.message,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingActionFailure(
          bookingId: event.bookingId,
          action: BookingActionType.extend,
          error: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingActionFailure(
          bookingId: event.bookingId,
          action: BookingActionType.extend,
          error: e.toString(),
        ));
      }
    }
  }

  /// Reset state to initial
  void _onResetState(
    ResetBookingActionState event,
    Emitter<BookingActionState> emit,
  ) {
    emit(const BookingActionInitial());
  }
}

