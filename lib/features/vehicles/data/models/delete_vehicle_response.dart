/// Delete Vehicle Response Model
/// Response from deleting a vehicle
class DeleteVehicleResponse {
  final bool status;
  final String message;

  const DeleteVehicleResponse({
    required this.status,
    required this.message,
  });

  factory DeleteVehicleResponse.fromJson(Map<String, dynamic> json) {
    return DeleteVehicleResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  /// Check if deletion was successful
  bool get isSuccess => status;
}

