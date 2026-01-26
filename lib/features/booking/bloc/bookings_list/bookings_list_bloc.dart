import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/booking_model.dart';
import '../../repository/booking_repository.dart';
import '../../../vehicles/domain/usecases/get_vehicles_usecase.dart';
import '../../../vehicles/domain/entities/vehicle_entity.dart';
import '../../../../core/injection/service_locator.dart';

part 'bookings_list_event.dart';
part 'bookings_list_state.dart';

/// Bookings List Bloc
/// Manages state for active and finished bookings list
class BookingsListBloc extends Bloc<BookingsListEvent, BookingsListState> {
  final GetVehiclesUseCase? _getVehiclesUseCase;

  BookingsListBloc({GetVehiclesUseCase? getVehiclesUseCase})
      : _getVehiclesUseCase = getVehiclesUseCase ?? getIt<GetVehiclesUseCase>(),
        super(const BookingsListInitial()) {
    on<LoadActiveBookings>(_onLoadActiveBookings);
    on<LoadFinishedBookings>(_onLoadFinishedBookings);
    on<RefreshBookings>(_onRefreshBookings);
    on<SwitchTab>(_onSwitchTab);
  }

  bool _currentTabIsActive = true;
  List<VehicleEntity>? _cachedVehicles;

  Future<void> _onLoadActiveBookings(
    LoadActiveBookings event,
    Emitter<BookingsListState> emit,
  ) async {
    emit(const BookingsListLoading());
    _currentTabIsActive = true;

    try {
      final response = await BookingRepository.getActiveBookings();
      final bookings = response.data ?? [];
      
      // Enrich bookings with vehicle information
      final enrichedBookings = await _enrichBookingsWithVehicles(bookings);
      
      emit(BookingsListLoaded(
        bookings: enrichedBookings,
        isActiveTab: true,
      ));
    } catch (e) {
      emit(BookingsListError(
        message: e.toString(),
      ));
    }
  }

  Future<void> _onLoadFinishedBookings(
    LoadFinishedBookings event,
    Emitter<BookingsListState> emit,
  ) async {
    emit(const BookingsListLoading());
    _currentTabIsActive = false;

    try {
      final response = await BookingRepository.getFinishedBookings();
      final bookings = response.data ?? [];
      
      // Enrich bookings with vehicle information
      final enrichedBookings = await _enrichBookingsWithVehicles(bookings);
      
      emit(BookingsListLoaded(
        bookings: enrichedBookings,
        isActiveTab: false,
      ));
    } catch (e) {
      emit(BookingsListError(
        message: e.toString(),
      ));
    }
  }

  /// Enrich bookings with vehicle information from vehicles list
  Future<List<BookingModel>> _enrichBookingsWithVehicles(
    List<BookingModel> bookings,
  ) async {
    // Load vehicles if not cached
    if (_cachedVehicles == null) {
      try {
        _cachedVehicles = await _getVehiclesUseCase?.call();
      } catch (e) {
        // If vehicles loading fails, return bookings without vehicle info
        return bookings;
      }
    }

    if (_cachedVehicles == null || _cachedVehicles!.isEmpty) {
      return bookings;
    }

    // Map bookings with vehicle information
    return bookings.map((booking) {
      if (booking.vehicle != null) {
        // Vehicle info already exists, return as is
        return booking;
      }

      // Find vehicle by vehicle_id
      try {
        final vehicle = _cachedVehicles!.firstWhere(
          (v) => v.vehicleId == booking.vehicleId,
        );

        // Create VehicleInfo from VehicleEntity
        final vehicleInfo = VehicleInfo(
          vehicleId: vehicle.vehicleId,
          platNumber: vehicle.platNumber,
          carMake: vehicle.carMake,
          carModel: vehicle.carModel,
          color: vehicle.color,
        );

        // Return booking with vehicle info
        return booking.copyWith(vehicle: vehicleInfo);
      } catch (e) {
        // Vehicle not found in cache, return booking without vehicle info
        return booking;
      }
    }).toList();
  }

  Future<void> _onRefreshBookings(
    RefreshBookings event,
    Emitter<BookingsListState> emit,
  ) async {
    if (_currentTabIsActive) {
      add(const LoadActiveBookings());
    } else {
      add(const LoadFinishedBookings());
    }
  }

  void _onSwitchTab(
    SwitchTab event,
    Emitter<BookingsListState> emit,
  ) {
    if (event.isActiveTab) {
      add(const LoadActiveBookings());
    } else {
      add(const LoadFinishedBookings());
    }
  }
}
