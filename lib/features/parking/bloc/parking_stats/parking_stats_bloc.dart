import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/owner_dashboard_stats_response.dart';
import '../../repository/parking_repository.dart';

part 'parking_stats_event.dart';
part 'parking_stats_state.dart';

/// Parking Stats BLoC
/// Manages owner dashboard statistics
/// Fetches revenue, bookings, and parking metrics
class ParkingStatsBloc extends Bloc<ParkingStatsEvent, ParkingStatsState> {
  ParkingStatsBloc() : super(const ParkingStatsInitial()) {
    on<LoadParkingStats>(_onLoadParkingStats);
    on<RefreshParkingStats>(_onRefreshParkingStats);
    on<FilterStatsByDateRange>(_onFilterStatsByDateRange);
  }

  /// Load parking statistics
  Future<void> _onLoadParkingStats(
    LoadParkingStats event,
    Emitter<ParkingStatsState> emit,
  ) async {
    // Avoid multiple concurrent loads
    if (state is ParkingStatsLoading) return;

    emit(const ParkingStatsLoading());

    try {
      final response = await ParkingRepository.getOwnerDashboardStats();

      if (!emit.isDone) {
        emit(ParkingStatsLoaded(
          response: response,
          dateRange: event.dateRange,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(ParkingStatsError(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ParkingStatsError(message: e.toString()));
      }
    }
  }

  /// Refresh statistics
  Future<void> _onRefreshParkingStats(
    RefreshParkingStats event,
    Emitter<ParkingStatsState> emit,
  ) async {
    final dateRange = state is ParkingStatsLoaded
        ? (state as ParkingStatsLoaded).dateRange
        : null;

    add(LoadParkingStats(dateRange: dateRange));
  }

  /// Filter statistics by date range
  void _onFilterStatsByDateRange(
    FilterStatsByDateRange event,
    Emitter<ParkingStatsState> emit,
  ) {
    if (state is! ParkingStatsLoaded) return;

    final currentState = state as ParkingStatsLoaded;

    emit(ParkingStatsLoaded(
      response: currentState.response,
      dateRange: event.dateRange,
    ));

    // Reload with new date range
    add(LoadParkingStats(dateRange: event.dateRange));
  }
}

