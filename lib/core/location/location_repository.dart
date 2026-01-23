import 'location_entity.dart';

/// Location Repository Interface
/// Abstract repository for location operations
/// 
/// This is part of the core layer and should not depend on:
/// - Flutter framework (except for platform-specific implementations)
/// - External location libraries directly in interface
abstract class LocationRepository {
  /// Get current user location
  /// 
  /// Returns the current location of the device.
  /// 
  /// Throws AppException on error:
  /// - Permission denied
  /// - Location service disabled
  /// - Network/GPS errors
  Future<LocationEntity> getCurrentLocation();

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled();

  /// Check location permission status
  /// Returns true if permission is granted
  Future<bool> checkLocationPermission();

  /// Request location permission
  /// Returns true if permission is granted
  Future<bool> requestLocationPermission();
}

