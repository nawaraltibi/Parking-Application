import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/update_parking_request.dart';
import '../../models/update_parking_response.dart';
import '../../repository/parking_repository.dart';

part 'update_parking_event.dart';
part 'update_parking_state.dart';

/// Update Parking BLoC
/// Manages parking lot update operations
/// Handles updating parking lot details
class UpdateParkingBloc extends Bloc<UpdateParkingEvent, UpdateParkingState> {
  UpdateParkingBloc() : super(const UpdateParkingInitial()) {
    on<LoadParkingForEdit>(_onLoadParkingForEdit);
    on<UpdateParkingField>(_onUpdateParkingField);
    on<SubmitUpdateParking>(_onSubmitUpdateParking);
    on<ResetUpdateParkingState>(_onResetState);
  }

  /// Load parking data for editing
  void _onLoadParkingForEdit(
    LoadParkingForEdit event,
    Emitter<UpdateParkingState> emit,
  ) {
    emit(UpdateParkingEditing(
      parkingId: event.parkingId,
      request: event.initialData,
    ));
  }

  /// Update a field in the parking request
  void _onUpdateParkingField(
    UpdateParkingField event,
    Emitter<UpdateParkingState> emit,
  ) {
    if (state is! UpdateParkingEditing) return;

    final currentState = state as UpdateParkingEditing;
    final updatedRequest = event.updateRequest(currentState.request);

    emit(UpdateParkingEditing(
      parkingId: currentState.parkingId,
      request: updatedRequest,
    ));
  }

  /// Submit update parking request
  Future<void> _onSubmitUpdateParking(
    SubmitUpdateParking event,
    Emitter<UpdateParkingState> emit,
  ) async {
    emit(UpdateParkingLoading(
      parkingId: event.parkingId,
      request: event.request,
    ));

    try {
      final response = await ParkingRepository.updateParking(
        parkingId: event.parkingId,
        updateRequest: event.request,
      );

      if (!emit.isDone) {
        emit(UpdateParkingSuccess(
          parkingId: event.parkingId,
          request: event.request,
          response: response,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(UpdateParkingFailure(
          parkingId: event.parkingId,
          request: event.request,
          error: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          validationErrors: e.errors,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(UpdateParkingFailure(
          parkingId: event.parkingId,
          request: event.request,
          error: e.toString(),
        ));
      }
    }
  }

  /// Reset state to initial
  void _onResetState(
    ResetUpdateParkingState event,
    Emitter<UpdateParkingState> emit,
  ) {
    emit(const UpdateParkingInitial());
  }
}

