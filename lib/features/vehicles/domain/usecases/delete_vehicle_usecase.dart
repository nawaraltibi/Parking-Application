import '../repositories/vehicles_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Delete Vehicle Use Case
/// Business logic for deleting a vehicle
class DeleteVehicleUseCase {
  final VehiclesRepository repository;

  DeleteVehicleUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Parameters:
  /// - [vehicleId]: ID of the vehicle to delete
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 404: Vehicle not found or doesn't belong to user
  /// - 409: Vehicle has active bookings
  /// - 500: Server errors
  Future<void> call({
    required int vehicleId,
  }) async {
    // Validate input
    if (vehicleId <= 0) {
      throw AppException(
        statusCode: 422,
        errorCode: 'validation-error',
        message: 'Invalid vehicle ID',
      );
    }

    try {
      await repository.deleteVehicle(vehicleId: vehicleId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to delete vehicle: ${e.toString()}',
      );
    }
  }
}

