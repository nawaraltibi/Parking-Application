/// Vehicle Entity
/// Pure domain entity representing a vehicle
/// No Flutter or external dependencies
class VehicleEntity {
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

  const VehicleEntity({
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

  /// Create a copy of VehicleEntity with updated fields
  VehicleEntity copyWith({
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
    return VehicleEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleEntity && other.vehicleId == vehicleId;
  }

  @override
  int get hashCode => vehicleId.hashCode;

  @override
  String toString() {
    return 'VehicleEntity(vehicleId: $vehicleId, platNumber: $platNumber, fullName: $fullName, status: $status)';
  }
}

