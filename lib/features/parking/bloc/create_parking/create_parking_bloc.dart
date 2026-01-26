import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/create_parking_request.dart';
import '../../models/create_parking_response.dart';
import '../../repository/parking_repository.dart';

part 'create_parking_event.dart';
part 'create_parking_state.dart';

/// Create Parking BLoC
/// Manages parking lot creation state and operations
/// Dedicated BLoC for createParking repository method
class CreateParkingBloc extends Bloc<CreateParkingEvent, CreateParkingState> {
  CreateParkingBloc()
      : super(CreateParkingInitial(
          request: CreateParkingRequest(
            lotName: '',
            address: '',
            latitude: 0.0,
            longitude: 0.0,
            totalSpaces: 0,
            hourlyRate: 0.0,
          ),
        )) {
    on<UpdateLotName>(_onUpdateLotName);
    on<UpdateAddress>(_onUpdateAddress);
    on<UpdateHourlyRate>(_onUpdateHourlyRate);
    on<UpdateTotalSpaces>(_onUpdateTotalSpaces);
    on<UpdateCoordinates>(_onUpdateCoordinates);
    on<SubmitCreateParking>(_onSubmitCreateParking);
    on<ResetCreateParkingState>(_onResetState);
  }

  /// Update lot name in the request
  void _onUpdateLotName(
    UpdateLotName event,
    Emitter<CreateParkingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(lotName: event.lotName);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Update address in the request
  void _onUpdateAddress(
    UpdateAddress event,
    Emitter<CreateParkingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(address: event.address);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Update hourly rate in the request
  void _onUpdateHourlyRate(
    UpdateHourlyRate event,
    Emitter<CreateParkingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(hourlyRate: event.rate);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Update total spaces in the request
  void _onUpdateTotalSpaces(
    UpdateTotalSpaces event,
    Emitter<CreateParkingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(totalSpaces: event.totalSpaces);
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Update coordinates in the request
  void _onUpdateCoordinates(
    UpdateCoordinates event,
    Emitter<CreateParkingState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      latitude: event.latitude,
      longitude: event.longitude,
    );
    emit(_updateStateWithRequest(updatedRequest));
  }

  /// Reset state to initial
  void _onResetState(
    ResetCreateParkingState event,
    Emitter<CreateParkingState> emit,
  ) {
    emit(CreateParkingInitial(
      request: CreateParkingRequest(
        lotName: '',
        address: '',
        latitude: 0.0,
        longitude: 0.0,
        totalSpaces: 0,
        hourlyRate: 0.0,
      ),
    ));
  }

  /// Submit create parking request
  Future<void> _onSubmitCreateParking(
    SubmitCreateParking event,
    Emitter<CreateParkingState> emit,
  ) async {
    final request = event.request;

    // Validate request
    if (request.lotName.isEmpty ||
        request.address.isEmpty ||
        request.hourlyRate <= 0 ||
        request.totalSpaces <= 0) {
      emit(CreateParkingFailure(
        request: request,
        error: 'invalid_parking_data',
      ));
      return;
    }

    emit(CreateParkingLoading(request: request));

    try {
      final response = await ParkingRepository.createParking(
        createRequest: request,
      );

      if (!emit.isDone) {
        emit(CreateParkingSuccess(
          request: request,
          response: response,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(CreateParkingFailure(
          request: request,
          error: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          validationErrors: e.errors,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(CreateParkingFailure(
          request: request,
          error: e.toString(),
        ));
      }
    }
  }

  /// Helper method to update state with new request while preserving state type
  CreateParkingState _updateStateWithRequest(CreateParkingRequest request) {
    if (state is CreateParkingLoading) {
      return CreateParkingLoading(request: request);
    } else if (state is CreateParkingSuccess) {
      return CreateParkingSuccess(
        request: request,
        response: (state as CreateParkingSuccess).response,
      );
    } else if (state is CreateParkingFailure) {
      final failure = state as CreateParkingFailure;
      return CreateParkingFailure(
        request: request,
        error: failure.error,
        statusCode: failure.statusCode,
        errorCode: failure.errorCode,
        validationErrors: failure.validationErrors,
      );
    } else {
      return CreateParkingInitial(request: request);
    }
  }
}

