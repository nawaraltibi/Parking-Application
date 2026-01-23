import 'vehicle_model.dart';

/// Add Vehicle Response Model
/// Response from creating a new vehicle
class AddVehicleResponse {
  final String message;
  final VehicleModel vehicle;

  const AddVehicleResponse({
    required this.message,
    required this.vehicle,
  });

  factory AddVehicleResponse.fromJson(Map<String, dynamic> json) {
    return AddVehicleResponse(
      message: json['message'] as String? ?? '',
      vehicle: VehicleModel.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      ),
    );
  }
}

