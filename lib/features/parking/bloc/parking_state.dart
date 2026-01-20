part of 'parking_cubit.dart';

/// Base class for parking states
abstract class ParkingState {}

/// Initial state
class ParkingInitial extends ParkingState {}

/// Loading state - loading parking list
class ParkingLoading extends ParkingState {}

/// Loaded state - parking list loaded successfully
class ParkingLoaded extends ParkingState {
  final List<ParkingModel> parkings;

  ParkingLoaded({required this.parkings});
}

/// Creating state - creating parking in progress
class ParkingCreating extends ParkingState {}

/// Creating success state - parking created successfully
class ParkingCreateSuccess extends ParkingState {
  final String message;
  final ParkingModel parkingLot;

  ParkingCreateSuccess({
    required this.message,
    required this.parkingLot,
  });
}

/// Updating state - updating parking in progress
class ParkingUpdating extends ParkingState {}

/// Update success state - parking updated successfully
class ParkingUpdateSuccess extends ParkingState {
  final String message;
  final ParkingModel parkingLot;

  ParkingUpdateSuccess({
    required this.message,
    required this.parkingLot,
  });
}

/// Failure state - parking operation failed
class ParkingFailure extends ParkingState {
  final String error;
  final int statusCode;

  ParkingFailure({
    required this.error,
    required this.statusCode,
  });
}

/// Dashboard loading state - loading dashboard stats
class DashboardLoading extends ParkingState {}

/// Dashboard loaded state - dashboard stats loaded successfully
class DashboardLoaded extends ParkingState {
  final DashboardData dashboardData;

  DashboardLoaded({required this.dashboardData});
}

/// Dashboard failure state - dashboard load failed
class DashboardFailure extends ParkingState {
  final String error;
  final int statusCode;

  DashboardFailure({
    required this.error,
    required this.statusCode,
  });
}

