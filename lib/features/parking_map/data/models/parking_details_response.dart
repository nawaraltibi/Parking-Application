import 'parking_details_model.dart';

/// Parking Details Response Model
/// Response wrapper for GET /api/parking/{id}
class ParkingDetailsResponse {
  final ParkingDetailsModel parking;
  final bool success;
  final String? message;

  const ParkingDetailsResponse({
    required this.parking,
    this.success = true,
    this.message,
  });

  factory ParkingDetailsResponse.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    ParkingDetailsModel parkingModel;

    // Backend returns: { 'status': true, 'message': '...', ...parkingData }
    // The parking data is at the root level, not nested
    if (json.containsKey('lot_id') || json.containsKey('id')) {
      parkingModel = ParkingDetailsModel.fromJson(json);
    }
    // Check if response has a 'data' key
    else if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      parkingModel = ParkingDetailsModel.fromJson(
          json['data'] as Map<String, dynamic>);
    }
    // Check if response has 'parking' key
    else if (json['parking'] != null &&
        json['parking'] is Map<String, dynamic>) {
      parkingModel = ParkingDetailsModel.fromJson(
          json['parking'] as Map<String, dynamic>);
    } else {
      throw FormatException(
          'Invalid parking details response format: ${json.keys}');
    }

    return ParkingDetailsResponse(
      parking: parkingModel,
      success: json['success'] as bool? ?? json['status'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': parking.toJson(),
      'success': success,
      'message': message,
    };
  }
}

