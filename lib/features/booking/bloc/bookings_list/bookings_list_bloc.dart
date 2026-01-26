import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/bookings_list_response.dart';
import '../../repository/booking_repository.dart';

part 'bookings_list_event.dart';
part 'bookings_list_state.dart';

/// Bookings List BLoC
/// Manages fetching and displaying lists of bookings (active/finished)
class BookingsListBloc extends Bloc<BookingsListEvent, BookingsListState> {
  BookingsListBloc() : super(const BookingsListInitial()) {
    on<LoadActiveBookings>(_onLoadActiveBookings);
    on<LoadFinishedBookings>(_onLoadFinishedBookings);
    on<RefreshBookings>(_onRefreshBookings);
  }

  /// Load active bookings (active + pending, not expired)
  Future<void> _onLoadActiveBookings(
    LoadActiveBookings event,
    Emitter<BookingsListState> emit,
  ) async {
    // Avoid multiple concurrent loads
    if (state is BookingsListLoading) return;

    emit(const BookingsListLoading(isActive: true));

    try {
      final response = await BookingRepository.getActiveBookings();

      if (!emit.isDone) {
        emit(BookingsListLoaded(
          response: response,
          isActive: true,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingsListError(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          isActive: true,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingsListError(
          message: e.toString(),
          isActive: true,
        ));
      }
    }
  }

  /// Load finished bookings (inactive or expired)
  Future<void> _onLoadFinishedBookings(
    LoadFinishedBookings event,
    Emitter<BookingsListState> emit,
  ) async {
    // Avoid multiple concurrent loads
    if (state is BookingsListLoading) return;

    emit(const BookingsListLoading(isActive: false));

    try {
      final response = await BookingRepository.getFinishedBookings();

      if (!emit.isDone) {
        emit(BookingsListLoaded(
          response: response,
          isActive: false,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingsListError(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          isActive: false,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingsListError(
          message: e.toString(),
          isActive: false,
        ));
      }
    }
  }

  /// Refresh current list (active or finished based on current state)
  Future<void> _onRefreshBookings(
    RefreshBookings event,
    Emitter<BookingsListState> emit,
  ) async {
    final isActive = state is BookingsListLoaded
        ? (state as BookingsListLoaded).isActive
        : true;

    if (isActive) {
      add(const LoadActiveBookings());
    } else {
      add(const LoadFinishedBookings());
    }
  }
}

