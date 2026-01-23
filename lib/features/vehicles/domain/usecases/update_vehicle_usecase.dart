import '../entities/vehicle_entity.dart';
import '../repositories/vehicles_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Update Vehicle Use Case
/// Business logic for updating a vehicle
/// 
/// Note: This creates a modification request that requires admin approval.
/// The vehicle is not updated immediately.
class UpdateVehicleUseCase {
  final VehiclesRepository repository;

  UpdateVehicleUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Parameters:
  /// - [vehicleId]: ID of the vehicle to update
  /// - [platNumber]: New vehicle plate number (must be unique)
  /// - [carMake]: New vehicle manufacturer
  /// - [carModel]: New vehicle model
  /// - [color]: New vehicle color
  /// 
  /// Returns the VehicleEntity (may still have old values if request is pending).
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 403: Vehicle is blocked
  /// - 404: Vehicle not found or doesn't belong to user
  /// - 422: Validation errors (duplicate plat_number, no changes, etc.)
  /// - 500: Server errors
  Future<VehicleEntity> call({
    required int vehicleId,
    required String platNumber,
    required String carMake,
    required String carModel,
    required String color,
  }) async {
    // Validate input
    if (vehicleId <= 0) {
      throw AppException(
        statusCode: 422,
        errorCode: 'validation-error',
        message: 'Invalid vehicle ID',
      );
    }

    if (platNumber.trim().isEmpty) {
      throw AppException(
        statusCode: 422,
        errorCode: 'validation-error',
        message: 'Plate number is required',
      );
    }

    if (carMake.trim().isEmpty) {
      throw AppException(
        statusCode: 422,
        errorCode: 'validation-error',
        message: 'Car make is required',
      );
    }

    if (carModel.trim().isEmpty) {
      throw AppException(
        statusCode: 422,
        errorCode: 'validation-error',
        message: 'Car model is required',
      );
    }

    if (color.trim().isEmpty) {
      throw AppException(
        statusCode: 422,
        errorCode: 'validation-error',
        message: 'Color is required',
      );
    }

    try {
      return await repository.updateVehicle(
        vehicleId: vehicleId,
        platNumber: platNumber.trim(),
        carMake: carMake.trim(),
        carModel: carModel.trim(),
        color: color.trim(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to update vehicle: ${e.toString()}',
      );
    }
  }
}

