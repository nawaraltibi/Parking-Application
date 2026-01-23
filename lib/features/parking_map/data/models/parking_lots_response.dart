import 'parking_lot_model.dart';

/// Parking Lots Response Model
/// Response wrapper for GET /api/allparkinginthemap
class ParkingLotsResponse {
  final List<ParkingLotModel> parkingLots;
  final bool success;
  final String? message;

  const ParkingLotsResponse({
    required this.parkingLots,
    this.success = true,
    this.message,
  });

  factory ParkingLotsResponse.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    List<ParkingLotModel> lots = [];

    // Backend returns: { 'message': '...', 'parkinglots': [...] }
    if (json['parkinglots'] != null && json['parkinglots'] is List) {
      final parkinglotsList = json['parkinglots'] as List;
      lots = parkinglotsList
          .map<ParkingLotModel>((item) => ParkingLotModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    }
    // Check if response has a 'data' key with a list
    else if (json['data'] != null && json['data'] is List) {
      final dataList = json['data'] as List;
      lots = dataList
          .map((item) => ParkingLotModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    }
    // Note: json is Map<String, dynamic>, not a List, so we skip this case
    // Check if response has 'parkings' or 'parking_lots' key
    else if (json['parkings'] != null && json['parkings'] is List) {
      final parkingsList = json['parkings'] as List;
      lots = parkingsList
          .map((item) => ParkingLotModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    } else if (json['parking_lots'] != null && json['parking_lots'] is List) {
      final parkingLotsList = json['parking_lots'] as List;
      lots = parkingLotsList
          .map((item) => ParkingLotModel.fromJson(
              item as Map<String, dynamic>))
          .toList();
    }
    // If response has individual parking fields, try to parse as single parking
    else if (json.containsKey('lot_id') || json.containsKey('id')) {
      lots = [ParkingLotModel.fromJson(json)];
    }

    return ParkingLotsResponse(
      parkingLots: lots,
      success: json['success'] as bool? ?? json['status'] as bool? ?? true,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': parkingLots.map((lot) => lot.toJson()).toList(),
      'success': success,
      'message': message,
    };
  }
}

