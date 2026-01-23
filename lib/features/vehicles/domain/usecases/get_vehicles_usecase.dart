import '../entities/vehicle_entity.dart';
import '../repositories/vehicles_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get Vehicles Use Case
/// Business logic for retrieving user vehicles
class GetVehiclesUseCase {
  final VehiclesRepository repository;

  GetVehiclesUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns a list of VehicleEntity objects for the authenticated user.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<VehicleEntity>> call() async {
    try {
      return await repository.getVehicles();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get vehicles: ${e.toString()}',
      );
    }
  }
}

