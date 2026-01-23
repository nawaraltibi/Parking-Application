import '../utils/app_exception.dart';
import 'location_entity.dart';
import 'location_repository.dart';

/// Get Current Location Use Case
/// Business logic for retrieving user's current location
class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns the current location of the device.
  /// 
  /// Throws AppException on error:
  /// - Permission denied
  /// - Location service disabled
  /// - Network/GPS errors
  Future<LocationEntity> call() async {
    try {
      return await repository.getCurrentLocation();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get current location: ${e.toString()}',
      );
    }
  }
}

