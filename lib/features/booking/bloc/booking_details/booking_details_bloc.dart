import 'dart:async';
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
  Timer? _remainingTimeTimer;
  BookingDetailsResponse? _cachedBookingDetails;

  BookingDetailsBloc() : super(const BookingDetailsInitial()) {
    on<LoadBookingDetails>(_onLoadBookingDetails);
    on<LoadRemainingTime>(_onLoadRemainingTime);
    on<RefreshBookingDetails>(_onRefreshBookingDetails);
    on<StartRemainingTimeTimer>(_onStartRemainingTimeTimer);
    on<StopRemainingTimeTimer>(_onStopRemainingTimeTimer);
    on<RemainingTimeTicked>(_onRemainingTimeTicked);
  }

  @override
  Future<void> close() {
    _remainingTimeTimer?.cancel();
    return super.close();
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
        // Debug: Check if data is null
        if (response.data == null) {
          emit(BookingDetailsError(
            bookingId: event.bookingId,
            message: 'Booking data is null',
          ));
          return;
        }

        // Cache booking details for timer updates
        _cachedBookingDetails = response;

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
    } catch (e, stackTrace) {
      // Print error for debugging
      print('Error loading booking details: $e');
      print('Stack trace: $stackTrace');
      
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

  /// Start real-time remaining time timer
  void _onStartRemainingTimeTimer(
    StartRemainingTimeTimer event,
    Emitter<BookingDetailsState> emit,
  ) {
    // Cancel existing timer if any
    _remainingTimeTimer?.cancel();

    // Don't load initial remaining time here - let the tick handler do it
    // This prevents state from changing to RemainingTimeLoaded before we have booking details
    
    // Start periodic timer (update every second)
    _remainingTimeTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!isClosed) {
          add(RemainingTimeTicked(bookingId: event.bookingId));
        } else {
          timer.cancel();
        }
      },
    );
    
    // Trigger first tick immediately
    add(RemainingTimeTicked(bookingId: event.bookingId));
  }

  /// Stop real-time remaining time timer
  void _onStopRemainingTimeTimer(
    StopRemainingTimeTimer event,
    Emitter<BookingDetailsState> emit,
  ) {
    _remainingTimeTimer?.cancel();
    _remainingTimeTimer = null;
  }

  /// Handle remaining time tick (fetch updated remaining time)
  Future<void> _onRemainingTimeTicked(
    RemainingTimeTicked event,
    Emitter<BookingDetailsState> emit,
  ) async {
    try {
      final remainingTimeResponse = await BookingRepository.getRemainingTime(
        bookingId: event.bookingId,
      );

      if (!emit.isDone) {
        // Use cached booking details if available, otherwise try current state
        BookingDetailsResponse? bookingResponse = _cachedBookingDetails;
        
        if (bookingResponse == null) {
          final currentState = state;
          if (currentState is BookingDetailsLoaded) {
            bookingResponse = currentState.response;
          } else if (currentState is RemainingTimeUpdated) {
            bookingResponse = currentState.response;
          }
        }

        if (bookingResponse != null) {
          // We have booking details, create RemainingTimeUpdated
          emit(RemainingTimeUpdated(
            bookingId: event.bookingId,
            response: bookingResponse,
            remainingTimeResponse: remainingTimeResponse,
          ));
        } else {
          // No booking details yet, skip this update
          // The next tick will have booking details after they're loaded
        }
      }
    } on AppException catch (e) {
      // On error, stop the timer
      _remainingTimeTimer?.cancel();
      _remainingTimeTimer = null;
      
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      // On error, stop the timer
      _remainingTimeTimer?.cancel();
      _remainingTimeTimer = null;
      
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.toString(),
        ));
      }
    }
  }
}

