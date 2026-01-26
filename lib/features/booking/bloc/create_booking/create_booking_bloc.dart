import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/create_booking_request.dart';
import '../../models/create_booking_response.dart';
import '../../repository/booking_repository.dart';

part 'create_booking_event.dart';
part 'create_booking_state.dart';

/// Create Booking BLoC
/// Manages booking creation state and operations
/// Dedicated BLoC for createBooking repository method
class CreateBookingBloc extends Bloc<CreateBookingEvent, CreateBookingState> {
  CreateBookingBloc()
      : super(CreateBookingInitial(
          request: CreateBookingRequest(lotId: 0, vehicleId: 0, hours: 1),
        )) {
    on<UpdateLotId>(_onUpdateLotId);
    on<UpdateVehicleId>(_onUpdateVehicleId);
    on<UpdateHours>(_onUpdateHours);
    on<SubmitCreateBooking>(_onSubmitCreateBooking);
    on<ResetCreateBookingState>(_onResetState);
  }

  /// Update lot ID in the request
  void _onUpdateLotId(
    UpdateLotId event,
    Emitter<CreateBookingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(lotId: event.lotId);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Update vehicle ID in the request
  void _onUpdateVehicleId(
    UpdateVehicleId event,
    Emitter<CreateBookingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(vehicleId: event.vehicleId);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Update hours in the request
  void _onUpdateHours(
    UpdateHours event,
    Emitter<CreateBookingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(hours: event.hours);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Reset state to initial
  void _onResetState(
    ResetCreateBookingState event,
    Emitter<CreateBookingState> emit,
  ) {
    emit(CreateBookingInitial(
      request: CreateBookingRequest(lotId: 0, vehicleId: 0, hours: 1),
    ));
  }

  /// Submit create booking request
  Future<void> _onSubmitCreateBooking(
    SubmitCreateBooking event,
    Emitter<CreateBookingState> emit,
  ) async {
    // Validate request
    if (state.request.lotId == 0 ||
        state.request.vehicleId == 0 ||
        state.request.hours < 1) {
      emit(CreateBookingFailure(
        request: state.request,
        error: 'invalid_booking_data',
      ));
      return;
    }

    emit(CreateBookingLoading(request: state.request));

    try {
      final response = await BookingRepository.createBooking(
        request: state.request,
      );

      if (!emit.isDone) {
        emit(CreateBookingSuccess(
          request: state.request,
          response: response,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(CreateBookingFailure(
          request: state.request,
          error: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          validationErrors: e.errors,
          responseData: e.responseData, // Include response data for special handling
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(CreateBookingFailure(
          request: state.request,
          error: e.toString(),
        ));
      }
    }
  }

  /// Helper method to update state with new request while preserving state type
  CreateBookingState _updateStateWithRequest(CreateBookingRequest request) {
    if (state is CreateBookingLoading) {
      return CreateBookingLoading(request: request);
    } else if (state is CreateBookingSuccess) {
      return CreateBookingSuccess(
        request: request,
        response: (state as CreateBookingSuccess).response,
      );
    } else if (state is CreateBookingFailure) {
      final failure = state as CreateBookingFailure;
      return CreateBookingFailure(
        request: request,
        error: failure.error,
        statusCode: failure.statusCode,
        errorCode: failure.errorCode,
        validationErrors: failure.validationErrors,
        responseData: failure.responseData,
      );
    } else {
      return CreateBookingInitial(request: request);
    }
  }
}

