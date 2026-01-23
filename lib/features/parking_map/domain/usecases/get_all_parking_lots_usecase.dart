import '../entities/parking_lot_entity.dart';
import '../repositories/parking_map_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get All Parking Lots Use Case
/// Business logic for retrieving all parking lots for map display
class GetAllParkingLotsUseCase {
  final ParkingMapRepository repository;

  GetAllParkingLotsUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns a list of ParkingLotEntity objects for map markers.
  /// Each entity contains location data (latitude, longitude) and basic info.
  /// 
  /// Throws AppException on error:
  /// - 500: Server errors
  /// - Network errors
  Future<List<ParkingLotEntity>> call() async {
    try {
      return await repository.getAllParkingLots();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get parking lots: ${e.toString()}',
      );
    }
  }
}

