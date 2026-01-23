/// Location Entity
/// Pure domain entity representing a geographic location
/// No Flutter or external dependencies
class LocationEntity {
  final double latitude;
  final double longitude;
  final double? accuracy; // in meters
  final double? altitude; // in meters
  final double? speed; // in m/s
  final DateTime? timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    this.timestamp,
  });

  /// Check if location is valid
  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  /// Create a copy of LocationEntity with updated fields
  LocationEntity copyWith({
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    DateTime? timestamp,
  }) {
    return LocationEntity(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LocationEntity &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);

  @override
  String toString() {
    return 'LocationEntity(lat: $latitude, lng: $longitude, accuracy: $accuracy)';
  }
}

