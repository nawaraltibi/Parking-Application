import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/parking_list_response.dart';
import '../../repository/parking_repository.dart';
import '../../core/enums/parking_filter.dart';

part 'parking_list_event.dart';
part 'parking_list_state.dart';

/// Parking List BLoC
/// Manages fetching and displaying lists of parking lots
/// Handles filtering and searching
class ParkingListBloc extends Bloc<ParkingListEvent, ParkingListState> {
  ParkingListBloc() : super(const ParkingListInitial()) {
    on<LoadOwnerParkings>(_onLoadOwnerParkings);
    on<LoadNearbyParkings>(_onLoadNearbyParkings);
    on<FilterParkings>(_onFilterParkings);
    on<SearchParkings>(_onSearchParkings);
    on<RefreshParkings>(_onRefreshParkings);
  }

  /// Load parking lots for the owner
  Future<void> _onLoadOwnerParkings(
    LoadOwnerParkings event,
    Emitter<ParkingListState> emit,
  ) async {
    // Avoid multiple concurrent loads
    if (state is ParkingListLoading) return;

    emit(const ParkingListLoading(isOwnerView: true));

    try {
      final response = await ParkingRepository.getOwnerParkings();

      if (!emit.isDone) {
        emit(ParkingListLoaded(
          response: response,
          isOwnerView: true,
          filter: ParkingFilter.all,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(ParkingListError(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          isOwnerView: true,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ParkingListError(
          message: e.toString(),
          isOwnerView: true,
        ));
      }
    }
  }

  /// Load nearby parking lots for users
  Future<void> _onLoadNearbyParkings(
    LoadNearbyParkings event,
    Emitter<ParkingListState> emit,
  ) async {
    // Avoid multiple concurrent loads
    if (state is ParkingListLoading) return;

    emit(const ParkingListLoading(isOwnerView: false));

    try {
      // TODO: Implement nearby parkings API call with coordinates
      // For now, use a placeholder
      throw UnimplementedError('Nearby parkings API not yet implemented');

      // final response = await ParkingRepository.getNearbyParkings(
      //   latitude: event.latitude,
      //   longitude: event.longitude,
      //   radius: event.radius,
      // );
      //
      // if (!emit.isDone) {
      //   emit(ParkingListLoaded(
      //     response: response,
      //     isOwnerView: false,
      //     filter: ParkingFilter.all,
      //   ));
      // }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(ParkingListError(
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
          isOwnerView: false,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ParkingListError(
          message: e.toString(),
          isOwnerView: false,
        ));
      }
    }
  }

  /// Filter parking lots
  void _onFilterParkings(
    FilterParkings event,
    Emitter<ParkingListState> emit,
  ) {
    if (state is! ParkingListLoaded) return;

    final currentState = state as ParkingListLoaded;

    emit(ParkingListLoaded(
      response: currentState.response,
      isOwnerView: currentState.isOwnerView,
      filter: event.filter,
      searchQuery: currentState.searchQuery,
    ));
  }

  /// Search parking lots
  void _onSearchParkings(
    SearchParkings event,
    Emitter<ParkingListState> emit,
  ) {
    if (state is! ParkingListLoaded) return;

    final currentState = state as ParkingListLoaded;

    emit(ParkingListLoaded(
      response: currentState.response,
      isOwnerView: currentState.isOwnerView,
      filter: currentState.filter,
      searchQuery: event.query,
    ));
  }

  /// Refresh current list
  Future<void> _onRefreshParkings(
    RefreshParkings event,
    Emitter<ParkingListState> emit,
  ) async {
    final isOwnerView = state is ParkingListLoaded
        ? (state as ParkingListLoaded).isOwnerView
        : true;

    if (isOwnerView) {
      add(const LoadOwnerParkings());
    } else {
      // Refresh nearby parkings if coordinates are available
      // For now, just reload owner parkings
      add(const LoadOwnerParkings());
    }
  }
}

