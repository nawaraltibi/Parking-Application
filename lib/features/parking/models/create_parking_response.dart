import 'parking_model.dart';

/// Create Parking Response Model
/// Response from POST /api/owner/parking/create endpoint
class CreateParkingResponse {
  final String message;
  final ParkingModel parkingLot;

  CreateParkingResponse({
    required this.message,
    required this.parkingLot,
  });

  factory CreateParkingResponse.fromJson(Map<String, dynamic> json) {
    return CreateParkingResponse(
      message: json['message'] as String? ?? '',
      parkingLot: json['parkingLot'] != null
          ? ParkingModel.fromJson(json['parkingLot'] as Map<String, dynamic>)
          : throw Exception('Parking lot data is required in create parking response'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'parkingLot': parkingLot.toJson(),
    };
  }
}

