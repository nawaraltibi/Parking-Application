import 'vehicle_model.dart';

/// Vehicles List Response Model
/// Response from getting user vehicles
class VehiclesListResponse {
  final String message;
  final List<VehicleModel> vehicles;

  const VehiclesListResponse({
    required this.message,
    required this.vehicles,
  });

  factory VehiclesListResponse.fromJson(Map<String, dynamic> json) {
    final vehiclesList = json['vehicle'] as List<dynamic>? ?? [];
    return VehiclesListResponse(
      message: json['message'] as String? ?? '',
      vehicles: vehiclesList
          .map((item) => VehicleModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

