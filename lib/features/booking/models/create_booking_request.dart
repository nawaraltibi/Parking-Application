/// Create Booking Request
/// Request body for creating a new parking booking
class CreateBookingRequest {
  final int lotId;
  final int vehicleId;
  final int hours;

  const CreateBookingRequest({
    required this.lotId,
    required this.vehicleId,
    required this.hours,
  });

  Map<String, dynamic> toJson() {
    return {
      'lot_id': lotId,
      'vehicle_id': vehicleId,
      'hours': hours,
    };
  }

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) {
    return CreateBookingRequest(
      lotId: json['lot_id'] as int,
      vehicleId: json['vehicle_id'] as int,
      hours: json['hours'] as int,
    );
  }

  /// Create a copy with updated fields
  CreateBookingRequest copyWith({
    int? lotId,
    int? vehicleId,
    int? hours,
  }) {
    return CreateBookingRequest(
      lotId: lotId ?? this.lotId,
      vehicleId: vehicleId ?? this.vehicleId,
      hours: hours ?? this.hours,
    );
  }
}

