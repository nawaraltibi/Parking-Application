import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../models/create_parking_request.dart';
import '../models/create_parking_response.dart';
import '../models/parking_list_response.dart';
import '../models/update_parking_request.dart';
import '../models/update_parking_response.dart';
import '../models/owner_dashboard_stats_response.dart';
import '../models/parking_model.dart';
import '../repository/parking_repository.dart';
import 'mixins/parking_error_handler_mixin.dart';

part 'parking_state.dart';

/// Parking Cubit
/// Manages parking state and business logic using Cubit pattern with AsyncRunner
class ParkingCubit extends Cubit<ParkingState> with ParkingErrorHandlerMixin {
  final AsyncRunner<ParkingListResponse> loadParkingsRunner =
      AsyncRunner<ParkingListResponse>();
  final AsyncRunner<CreateParkingResponse> createParkingRunner =
      AsyncRunner<CreateParkingResponse>();
  final AsyncRunner<UpdateParkingResponse> updateParkingRunner =
      AsyncRunner<UpdateParkingResponse>();
  final AsyncRunner<OwnerDashboardStatsResponse> dashboardStatsRunner =
      AsyncRunner<OwnerDashboardStatsResponse>();

  ParkingCubit() : super(ParkingInitial());

  /// Load owner parking lots
  Future<void> loadParkings() async {
    emit(ParkingLoading());

    await loadParkingsRunner.run(
      onlineTask: (previousResult) async {
        final response = await ParkingRepository.getOwnerParkings();
        return response;
      },
      onSuccess: (response) async {
        if (!isClosed) {
          emit(ParkingLoaded(parkings: response.data));
        }
      },
      onError: (error) {
        if (!isClosed) {
          handleError(error);
        }
      },
    );
  }

  /// Create new parking lot
  Future<void> createParking(CreateParkingRequest request) async {
    // Validate request locally first
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      emit(ParkingFailure(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(ParkingCreating());

    await createParkingRunner.run(
      onlineTask: (previousResult) async {
        final response = await ParkingRepository.createParking(
          createRequest: request,
        );
        return response;
      },
      onSuccess: (response) async {
        if (!isClosed) {
          emit(ParkingCreateSuccess(
            message: response.message,
            parkingLot: response.parkingLot,
          ));
          // Reload parkings to show new one
          await loadParkings();
        }
      },
      onError: (error) {
        if (!isClosed) {
          handleError(error);
        }
      },
    );
  }

  /// Update existing parking lot
  Future<void> updateParking(
    int parkingId,
    UpdateParkingRequest request,
  ) async {
    // Validate request locally first
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      emit(ParkingFailure(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(ParkingUpdating());

    await updateParkingRunner.run(
      onlineTask: (previousResult) async {
        final response = await ParkingRepository.updateParking(
          parkingId: parkingId,
          updateRequest: request,
        );
        return response;
      },
      onSuccess: (response) async {
        if (!isClosed) {
          emit(ParkingUpdateSuccess(
            message: response.message,
            parkingLot: response.parkinglot,
          ));
          // Reload parkings to show updated one
          await loadParkings();
        }
      },
      onError: (error) {
        if (!isClosed) {
          handleError(error);
        }
      },
    );
  }

  /// Load owner dashboard statistics
  Future<void> loadDashboardStats() async {
    emit(DashboardLoading());

    await dashboardStatsRunner.run(
      onlineTask: (previousResult) async {
        final response = await ParkingRepository.getOwnerDashboardStats();
        return response;
      },
      onSuccess: (response) async {
        if (!isClosed) {
          emit(DashboardLoaded(dashboardData: response.data));
        }
      },
      onError: (error) {
        if (!isClosed) {
          handleError(error, isDashboard: true);
        }
      },
    );
  }

  /// Add parking optimistically to the list (without API call)
  /// This provides instant UI feedback
  void addParking(ParkingModel parking) {
    final currentState = state;
    if (currentState is ParkingLoaded) {
      // Create new list with parking added at the beginning
      final updatedList = [parking, ...currentState.parkings];
      emit(ParkingLoaded(parkings: updatedList));
    }
  }

  /// Update parking in the list optimistically
  void updateParkingInList(ParkingModel updatedParking) {
    final currentState = state;
    if (currentState is ParkingLoaded) {
      final updatedList = currentState.parkings.map((p) {
        return p.lotId == updatedParking.lotId ? updatedParking : p;
      }).toList();
      emit(ParkingLoaded(parkings: updatedList));
    }
  }

  /// Reset state to initial
  void resetState() {
    emit(ParkingInitial());
  }
}

