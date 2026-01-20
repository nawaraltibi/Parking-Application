import 'parking_model.dart';

/// Parking List Response Model
/// Response from GET /api/owner/parking/data endpoint
class ParkingListResponse {
  final String message;
  final List<ParkingModel> data;

  ParkingListResponse({
    required this.message,
    required this.data,
  });

  factory ParkingListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'];
    List<ParkingModel> parkingList = [];

    if (dataList != null) {
      if (dataList is List) {
        parkingList = dataList
            .map((item) => ParkingModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (dataList is Map<String, dynamic>) {
        // Handle case where data might be a single object wrapped in map
        parkingList = [ParkingModel.fromJson(dataList)];
      }
    }

    return ParkingListResponse(
      message: json['message'] as String? ?? '',
      data: parkingList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((parking) => parking.toJson()).toList(),
    };
  }
}

