/// Update Parking Request Model
/// Request body for updating a parking lot
class UpdateParkingRequest {
  final String lotName;
  final String address;
  final double latitude;
  final double longitude;
  final int totalSpaces;
  final double hourlyRate;

  UpdateParkingRequest({
    this.lotName = '',
    this.address = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.totalSpaces = 0,
    this.hourlyRate = 0.0,
  });

  /// Create a copy of UpdateParkingRequest with updated fields
  UpdateParkingRequest copyWith({
    String? lotName,
    String? address,
    double? latitude,
    double? longitude,
    int? totalSpaces,
    double? hourlyRate,
  }) {
    return UpdateParkingRequest(
      lotName: lotName ?? this.lotName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalSpaces: totalSpaces ?? this.totalSpaces,
      hourlyRate: hourlyRate ?? this.hourlyRate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lot_name': lotName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_spaces': totalSpaces,
      'hourly_rate': hourlyRate,
    };
  }

  /// Validate request data
  /// Returns list of validation error messages
  List<String> validate() {
    final errors = <String>[];

    if (lotName.trim().isEmpty) {
      errors.add('Lot name is required');
    }

    if (address.trim().isEmpty) {
      errors.add('Address is required');
    }

    if (latitude < -90 || latitude > 90) {
      errors.add('Latitude must be between -90 and 90');
    }

    if (longitude < -180 || longitude > 180) {
      errors.add('Longitude must be between -180 and 180');
    }

    if (totalSpaces < 1) {
      errors.add('Total spaces must be at least 1');
    }

    if (hourlyRate < 0) {
      errors.add('Hourly rate must be 0 or greater');
    }

    return errors;
  }
}

