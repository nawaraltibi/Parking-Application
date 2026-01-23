/// Vehicle Model
/// Represents a vehicle entity in the Parking Application system
class VehicleModel {
  final int vehicleId;
  final String platNumber;
  final String carMake;
  final String carModel;
  final String color;
  final String status; // 'active' or 'inactive'
  final String requestStatus; // 'accept', 'reject', or 'pending'
  final int userId;
  final String? createdAt;
  final String? updatedAt;

  const VehicleModel({
    required this.vehicleId,
    required this.platNumber,
    required this.carMake,
    required this.carModel,
    required this.color,
    required this.status,
    required this.requestStatus,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper method to safely convert dynamic value to int
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  /// Helper method to safely convert dynamic value to String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: _parseInt(json['vehicle_id'] ?? json['id']),
      platNumber: _parseString(json['plat_number']),
      carMake: _parseString(json['car_make']),
      carModel: _parseString(json['car_model']),
      color: _parseString(json['color']),
      status: _parseString(json['status'], defaultValue: 'active'),
      requestStatus: _parseString(
        json['requeststatus'] ?? json['request_status'],
        defaultValue: 'accept',
      ),
      userId: _parseInt(json['user_id']),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'plat_number': platNumber,
      'car_make': carMake,
      'car_model': carModel,
      'color': color,
      'status': status,
      'requeststatus': requestStatus,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Create a copy of VehicleModel with updated fields
  VehicleModel copyWith({
    int? vehicleId,
    String? platNumber,
    String? carMake,
    String? carModel,
    String? color,
    String? status,
    String? requestStatus,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return VehicleModel(
      vehicleId: vehicleId ?? this.vehicleId,
      platNumber: platNumber ?? this.platNumber,
      carMake: carMake ?? this.carMake,
      carModel: carModel ?? this.carModel,
      color: color ?? this.color,
      status: status ?? this.status,
      requestStatus: requestStatus ?? this.requestStatus,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if vehicle is active
  bool get isActive => status == 'active';

  /// Check if vehicle is inactive
  bool get isInactive => status == 'inactive';

  /// Check if modification request is pending
  bool get isModificationPending => requestStatus == 'pending';

  /// Check if modification request is accepted
  bool get isModificationAccepted => requestStatus == 'accept';

  /// Check if modification request is rejected
  bool get isModificationRejected => requestStatus == 'reject';

  /// Get full vehicle name
  String get fullName => '$carMake $carModel';

  /// Get display status
  String get statusDisplay {
    if (isInactive) return 'Blocked';
    if (isModificationPending) return 'Modification Pending';
    return 'Active';
  }
}

