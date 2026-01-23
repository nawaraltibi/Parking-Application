import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/create_parking_request.dart';
import '../models/update_parking_request.dart';
import '../models/owner_dashboard_stats_response.dart';
import '../models/parking_model.dart';
import '../repository/parking_repository.dart';
import '../../../core/utils/app_exception.dart';

part 'parking_state.dart';

/// Parking Cubit
/// 
/// Clean, simple state management for parking operations.
/// 
/// Key Design Principles:
/// 1. Single source of truth: The parking list is always in state
/// 2. Direct updates: Create/Update operations directly modify the list
/// 3. No separate success states: Operations update state immediately
/// 4. Predictable: State changes are clear and traceable
/// 
/// Why Cubit over Bloc:
/// - Simpler API (methods instead of events)
/// - Less boilerplate
/// - Easier to understand and maintain
/// - Perfect for CRUD operations like this
class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(const ParkingState.initial());

  /// Load all parking lots for the owner
  Future<void> loadParkings() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await ParkingRepository.getOwnerParkings();
      emit(state.copyWith(
        parkings: response.data,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      emit(state.copyWith(
        isLoading: false,
        error: errorMessage,
      ));
    }
  }

  /// Create a new parking lot
  /// 
  /// After successful creation:
  /// 1. Adds the new parking to the list immediately
  /// 2. Emits updated state with the new parking included
  /// 3. No need to reload - the list is already updated
  Future<void> createParking(CreateParkingRequest request) async {
    // Validate request locally first
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(state.copyWith(isCreating: true, error: null));

    try {
      final response = await ParkingRepository.createParking(
        createRequest: request,
      );

      // Add the new parking to the list immediately
      final updatedParkings = [response.parkingLot, ...state.parkings];
      
      emit(state.copyWith(
        parkings: updatedParkings,
        isCreating: false,
        error: null,
      ));
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      emit(state.copyWith(
        isCreating: false,
        error: errorMessage,
        statusCode: _extractStatusCode(e),
      ));
    }
  }

  /// Update an existing parking lot
  /// 
  /// After successful update:
  /// 1. Replaces the old parking with the updated one in the list
  /// 2. Emits updated state with the modified parking
  /// 3. No need to reload - the list is already updated
  Future<void> updateParking({
    required int parkingId,
    required UpdateParkingRequest request,
  }) async {
    // Validate request locally first
    final validationErrors = request.validate();
    if (validationErrors.isNotEmpty) {
      emit(state.copyWith(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(state.copyWith(isUpdating: true, error: null));

    try {
      final response = await ParkingRepository.updateParking(
        parkingId: parkingId,
        updateRequest: request,
      );

      // Replace the old parking with the updated one
      final updatedParkings = state.parkings.map((parking) {
        return parking.lotId == parkingId
            ? response.parkinglot
            : parking;
      }).toList();
      
      emit(state.copyWith(
        parkings: updatedParkings,
        isUpdating: false,
        error: null,
      ));
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      emit(state.copyWith(
        isUpdating: false,
        error: errorMessage,
        statusCode: _extractStatusCode(e),
      ));
    }
  }

  /// Load dashboard statistics
  Future<void> loadDashboardStats() async {
    emit(state.copyWith(isLoadingDashboard: true, dashboardError: null));

    try {
      final response = await ParkingRepository.getOwnerDashboardStats();
      emit(state.copyWith(
        dashboardData: response.data,
        isLoadingDashboard: false,
        dashboardError: null,
      ));
    } catch (e) {
      final errorMessage = _extractErrorMessage(e);
      emit(state.copyWith(
        isLoadingDashboard: false,
        dashboardError: errorMessage,
        dashboardStatusCode: _extractStatusCode(e),
      ));
    }
  }

  /// Clear any error state
  void clearError() {
    emit(state.copyWith(error: null, statusCode: null));
  }

  /// Clear dashboard error state
  void clearDashboardError() {
    emit(state.copyWith(dashboardError: null, dashboardStatusCode: null));
  }

  /// Extract error message from exception
  String _extractErrorMessage(Object error) {
    if (error is AppException) {
      if (error.errors != null && error.errors!.isNotEmpty) {
        final errorList = <String>[];
        error.errors!.forEach((key, value) {
          errorList.addAll(value);
        });
        if (errorList.isNotEmpty) {
          return errorList.join('\n');
        }
      }
      return error.message;
    }
    return error.toString();
  }

  /// Extract status code from exception
  int? _extractStatusCode(Object error) {
    if (error is AppException) {
      return error.statusCode;
    }
    return 500;
  }
}

