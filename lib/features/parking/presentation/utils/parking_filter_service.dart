import '../../core/enums/parking_filter.dart';
import '../../models/parking_model.dart';

/// Service for filtering parking lots
class ParkingFilterService {
  /// Filter parkings based on search query and filter type
  static List<ParkingModel> filterParkings({
    required List<ParkingModel> parkings,
    required String searchQuery,
    required ParkingFilter filter,
  }) {
    return parkings.where((parking) {
      final matchesSearch = searchQuery.isEmpty ||
          parking.lotName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          parking.address.toLowerCase().contains(searchQuery.toLowerCase());
      
      final matchesFilter = filter.matches(parking);
      
      return matchesSearch && matchesFilter;
    }).toList();
  }
}

