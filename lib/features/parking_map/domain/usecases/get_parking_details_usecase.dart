import '../entities/parking_details_entity.dart';
import '../repositories/parking_map_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get Parking Details Use Case
/// Business logic for retrieving detailed parking information
class GetParkingDetailsUseCase {
  final ParkingMapRepository repository;

  GetParkingDetailsUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns detailed ParkingDetailsEntity for the specified parking lot.
  /// This is called when a user clicks on a parking marker on the map.
  /// 
  /// Throws AppException on error:
  /// - 404: Parking lot not found
  /// - 500: Server errors
  /// - Network errors
  Future<ParkingDetailsEntity> call({
    required int lotId,
  }) async {
    try {
      return await repository.getParkingDetails(lotId: lotId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get parking details: ${e.toString()}',
      );
    }
  }
}

