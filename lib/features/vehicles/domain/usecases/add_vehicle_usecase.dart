import '../entities/vehicle_entity.dart';
import '../repositories/vehicles_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Add Vehicle Use Case
/// Business logic for adding a new vehicle
class AddVehicleUseCase {
  final VehiclesRepository repository;

  AddVehicleUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Parameters:
  /// - [platNumber]: Vehicle plate number (must be unique)
  /// - [carMake]: Vehicle manufacturer (e.g., "Toyota")
  /// - [carModel]: Vehicle model (e.g., "Camry")
  /// - [color]: Vehicle color (e.g., "Blue")
  /// 
  /// Returns the created VehicleEntity.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 422: Validation errors (duplicate plat_number, missing fields, etc.)
  /// - 500: Server errors
  Future<VehicleEntity> call({
    required String platNumber,
    required String carMake,
    required String carModel,
    required String color,
  }) async {
    // Validate input
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
      return await repository.addVehicle(
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
        message: 'Failed to add vehicle: ${e.toString()}',
      );
    }
  }
}

