import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/booking_details_response.dart';
import '../../models/remaining_time_response.dart';
import '../../repository/booking_repository.dart';

part 'booking_details_event.dart';
part 'booking_details_state.dart';

/// Booking Details BLoC
/// Manages fetching booking details and remaining time
class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  BookingDetailsBloc() : super(const BookingDetailsInitial()) {
    on<LoadBookingDetails>(_onLoadBookingDetails);
    on<LoadRemainingTime>(_onLoadRemainingTime);
    on<RefreshBookingDetails>(_onRefreshBookingDetails);
  }

  /// Load booking details
  Future<void> _onLoadBookingDetails(
    LoadBookingDetails event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(BookingDetailsLoading(bookingId: event.bookingId));

    try {
      final response = await BookingRepository.getBookingDetails(
        bookingId: event.bookingId,
      );

      if (!emit.isDone) {
        emit(BookingDetailsLoaded(
          bookingId: event.bookingId,
          response: response,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.toString(),
        ));
      }
    }
  }

  /// Load remaining time for a booking
  Future<void> _onLoadRemainingTime(
    LoadRemainingTime event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(RemainingTimeLoading(bookingId: event.bookingId));

    try {
      final response = await BookingRepository.getRemainingTime(
        bookingId: event.bookingId,
      );

      if (!emit.isDone) {
        emit(RemainingTimeLoaded(
          bookingId: event.bookingId,
          response: response,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.toString(),
        ));
      }
    }
  }

  /// Refresh current booking details
  Future<void> _onRefreshBookingDetails(
    RefreshBookingDetails event,
    Emitter<BookingDetailsState> emit,
  ) async {
    if (state is BookingDetailsLoaded) {
      final currentState = state as BookingDetailsLoaded;
      add(LoadBookingDetails(bookingId: currentState.bookingId));
    } else if (state is RemainingTimeLoaded) {
      final currentState = state as RemainingTimeLoaded;
      add(LoadRemainingTime(bookingId: currentState.bookingId));
    }
  }
}

