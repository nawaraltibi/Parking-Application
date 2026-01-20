import 'parking_model.dart';

/// Update Parking Response Model
/// Response from PUT /api/owner/parking/update/:id endpoint
class UpdateParkingResponse {
  final String message;
  final ParkingModel parkinglot;

  UpdateParkingResponse({
    required this.message,
    required this.parkinglot,
  });

  factory UpdateParkingResponse.fromJson(Map<String, dynamic> json) {
    return UpdateParkingResponse(
      message: json['message'] as String? ?? '',
      parkinglot: json['parkinglot'] != null
          ? ParkingModel.fromJson(json['parkinglot'] as Map<String, dynamic>)
          : throw Exception('Parking lot data is required in update parking response'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'parkinglot': parkinglot.toJson(),
    };
  }
}

