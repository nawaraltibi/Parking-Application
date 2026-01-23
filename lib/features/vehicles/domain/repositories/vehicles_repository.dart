import '../entities/vehicle_entity.dart';

/// Vehicles Repository Interface
/// Abstract repository for vehicle operations
/// 
/// This is part of the domain layer and should not depend on:
/// - Flutter framework
/// - Data layer implementations
/// - External libraries (except core utilities)
abstract class VehiclesRepository {
  /// Get all vehicles for the authenticated user
  /// 
  /// Returns a list of VehicleEntity objects.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<VehicleEntity>> getVehicles();

  /// Add a new vehicle
  /// 
  /// Returns the created VehicleEntity.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 422: Validation errors (duplicate plat_number, missing fields, etc.)
  /// - 500: Server errors
  Future<VehicleEntity> addVehicle({
    required String platNumber,
    required String carMake,
    required String carModel,
    required String color,
  });

  /// Update a vehicle
  /// 
  /// Note: This creates a modification request that requires admin approval.
  /// The vehicle is not updated immediately.
  /// 
  /// Returns the VehicleEntity (may still have old values if request is pending).
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 403: Vehicle is blocked
  /// - 404: Vehicle not found or doesn't belong to user
  /// - 422: Validation errors (duplicate plat_number, no changes, etc.)
  /// - 500: Server errors
  Future<VehicleEntity> updateVehicle({
    required int vehicleId,
    required String platNumber,
    required String carMake,
    required String carModel,
    required String color,
  });

  /// Delete a vehicle
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 404: Vehicle not found or doesn't belong to user
  /// - 409: Vehicle has active bookings
  /// - 500: Server errors
  Future<void> deleteVehicle({
    required int vehicleId,
  });
}

