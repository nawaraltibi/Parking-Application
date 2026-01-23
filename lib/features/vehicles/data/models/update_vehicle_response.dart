import 'vehicle_model.dart';

/// Update Vehicle Response Model
/// Response from updating a vehicle
/// Note: Update creates a modification request that requires admin approval
class UpdateVehicleResponse {
  final String message;
  final int? requestId; // Present when modification request is created
  final VehicleModel vehicle;

  const UpdateVehicleResponse({
    required this.message,
    this.requestId,
    required this.vehicle,
  });

  factory UpdateVehicleResponse.fromJson(Map<String, dynamic> json) {
    return UpdateVehicleResponse(
      message: json['message'] as String? ?? '',
      requestId: json['request_id'] as int?,
      vehicle: VehicleModel.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      ),
    );
  }

  /// Check if this is a new modification request
  bool get isNewRequest => requestId != null;

  /// Check if existing request was updated
  bool get isExistingRequestUpdated => message.contains('existing update request');
}

