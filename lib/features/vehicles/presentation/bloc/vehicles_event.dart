part of 'vehicles_bloc.dart';

/// Base class for vehicles events
abstract class VehiclesEvent {}

/// Event to get vehicles for the authenticated user
class GetVehiclesRequested extends VehiclesEvent {
  GetVehiclesRequested();
}

/// Event to add a new vehicle
class AddVehicleRequested extends VehiclesEvent {
  final String platNumber;
  final String carMake;
  final String carModel;
  final String color;

  AddVehicleRequested({
    required this.platNumber,
    required this.carMake,
    required this.carModel,
    required this.color,
  });
}

/// Event to update a vehicle
/// Note: This creates a modification request that requires admin approval
class UpdateVehicleRequested extends VehiclesEvent {
  final int vehicleId;
  final String platNumber;
  final String carMake;
  final String carModel;
  final String color;

  UpdateVehicleRequested({
    required this.vehicleId,
    required this.platNumber,
    required this.carMake,
    required this.carModel,
    required this.color,
  });
}

/// Event to delete a vehicle
class DeleteVehicleRequested extends VehiclesEvent {
  final int vehicleId;

  DeleteVehicleRequested({
    required this.vehicleId,
  });
}

/// Event to reset vehicles state
class ResetVehiclesState extends VehiclesEvent {
  ResetVehiclesState();
}

