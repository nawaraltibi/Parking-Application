/// Map Point
/// Abstraction for a geographic point (latitude, longitude)
/// Independent of map provider (OSM, Google Maps, etc.)
class MapPoint {
  final double latitude;
  final double longitude;

  const MapPoint({
    required this.latitude,
    required this.longitude,
  });

  /// Check if point is valid
  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Create MapPoint from LocationEntity
  factory MapPoint.fromLocationEntity(dynamic locationEntity) {
    return MapPoint(
      latitude: locationEntity.latitude,
      longitude: locationEntity.longitude,
    );
  }

  /// Convert to GeoPoint (for flutter_osm_plugin)
  /// This is the only place where we depend on a specific map library
  dynamic toGeoPoint() {
    // Import is done at usage site to keep this file clean
    // This will be handled by map_adapter
    return {'latitude': latitude, 'longitude': longitude};
  }

  /// Create a copy of MapPoint with updated fields
  MapPoint copyWith({
    double? latitude,
    double? longitude,
  }) {
    return MapPoint(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapPoint &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() {
    return 'MapPoint(lat: $latitude, lng: $longitude)';
  }
}

