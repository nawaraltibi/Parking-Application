/// Booking Model
/// Represents a parking booking in the system
class BookingModel {
  final int bookingId;
  final String startTime;
  final String endTime;
  final String status; // 'active', 'inactive', 'pending'
  final double totalAmount;
  final int userId;
  final int vehicleId;
  final int lotId;
  final int? pendingExtraHours;
  final String? createdAt;
  final String? updatedAt;

  // Related models (can be populated when using eager loading)
  final ParkingLotInfo? parkingLot;
  final VehicleInfo? vehicle;
  final PaymentInfo? payment;

  const BookingModel({
    required this.bookingId,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalAmount,
    required this.userId,
    required this.vehicleId,
    required this.lotId,
    this.pendingExtraHours,
    this.createdAt,
    this.updatedAt,
    this.parkingLot,
    this.vehicle,
    this.payment,
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

  /// Helper method to safely convert dynamic value to double
  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
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

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: _parseInt(json['booking_id']),
      startTime: _parseString(json['start_time']),
      endTime: _parseString(json['end_time']),
      status: _parseString(json['status']),
      totalAmount: _parseDouble(json['total_amount']),
      userId: _parseInt(json['user_id']),
      vehicleId: _parseInt(json['vehicle_id']),
      lotId: _parseInt(json['lot_id']),
      pendingExtraHours: json['pending_extra_hours'] != null
          ? _parseInt(json['pending_extra_hours'])
          : null,
      createdAt: json['created_at'] != null
          ? _parseString(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? _parseString(json['updated_at'])
          : null,
      parkingLot: json['parking_lot'] != null
          ? ParkingLotInfo.fromJson(json['parking_lot'])
          : null,
      vehicle: json['vehicle'] != null
          ? VehicleInfo.fromJson(json['vehicle'])
          : null,
      payment: json['payment'] != null
          ? PaymentInfo.fromJson(json['payment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'total_amount': totalAmount,
      'user_id': userId,
      'vehicle_id': vehicleId,
      'lot_id': lotId,
      'pending_extra_hours': pendingExtraHours,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (parkingLot != null) 'parking_lot': parkingLot!.toJson(),
      if (vehicle != null) 'vehicle': vehicle!.toJson(),
      if (payment != null) 'payment': payment!.toJson(),
    };
  }

  /// Check if booking is active
  bool get isActive => status == 'active';

  /// Check if booking is pending (waiting for payment)
  bool get isPending => status == 'pending';

  /// Check if booking is inactive (cancelled or expired)
  bool get isInactive => status == 'inactive';

  /// Check if booking has pending extension
  bool get hasPendingExtension => pendingExtraHours != null && pendingExtraHours! > 0;

  /// Create a copy of BookingModel with updated fields
  BookingModel copyWith({
    int? bookingId,
    String? startTime,
    String? endTime,
    String? status,
    double? totalAmount,
    int? userId,
    int? vehicleId,
    int? lotId,
    int? pendingExtraHours,
    String? createdAt,
    String? updatedAt,
    ParkingLotInfo? parkingLot,
    VehicleInfo? vehicle,
    PaymentInfo? payment,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      userId: userId ?? this.userId,
      vehicleId: vehicleId ?? this.vehicleId,
      lotId: lotId ?? this.lotId,
      pendingExtraHours: pendingExtraHours ?? this.pendingExtraHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parkingLot: parkingLot ?? this.parkingLot,
      vehicle: vehicle ?? this.vehicle,
      payment: payment ?? this.payment,
    );
  }
}

/// Parking Lot Information (nested in Booking)
class ParkingLotInfo {
  final int lotId;
  final String lotName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? totalSpaces;
  final double? hourlyRate;

  const ParkingLotInfo({
    required this.lotId,
    required this.lotName,
    this.address,
    this.latitude,
    this.longitude,
    this.totalSpaces,
    this.hourlyRate,
  });

  factory ParkingLotInfo.fromJson(Map<String, dynamic> json) {
    return ParkingLotInfo(
      lotId: BookingModel._parseInt(json['lot_id']),
      lotName: BookingModel._parseString(json['lot_name']),
      address: json['address'] != null
          ? BookingModel._parseString(json['address'])
          : null,
      latitude: json['latitude'] != null
          ? BookingModel._parseDouble(json['latitude'])
          : null,
      longitude: json['longitude'] != null
          ? BookingModel._parseDouble(json['longitude'])
          : null,
      totalSpaces: json['total_spaces'] != null
          ? BookingModel._parseInt(json['total_spaces'])
          : null,
      hourlyRate: json['hourly_rate'] != null
          ? BookingModel._parseDouble(json['hourly_rate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lot_id': lotId,
      'lot_name': lotName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_spaces': totalSpaces,
      'hourly_rate': hourlyRate,
    };
  }
}

/// Vehicle Information (nested in Booking)
class VehicleInfo {
  final int vehicleId;
  final String platNumber;
  final String? carMake;
  final String? carModel;
  final String? color;

  const VehicleInfo({
    required this.vehicleId,
    required this.platNumber,
    this.carMake,
    this.carModel,
    this.color,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      vehicleId: BookingModel._parseInt(json['vehicle_id']),
      platNumber: BookingModel._parseString(json['plat_number']),
      carMake: json['car_make'] != null
          ? BookingModel._parseString(json['car_make'])
          : null,
      carModel: json['car_model'] != null
          ? BookingModel._parseString(json['car_model'])
          : null,
      color: json['color'] != null ? BookingModel._parseString(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'plat_number': platNumber,
      'car_make': carMake,
      'car_model': carModel,
      'color': color,
    };
  }
}

/// Payment Information (nested in Booking)
class PaymentInfo {
  final int paymentId;
  final double amount;
  final String paymentMethod;
  final String status;
  final String? transactionId;

  const PaymentInfo({
    required this.paymentId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      paymentId: BookingModel._parseInt(json['payment_id']),
      amount: BookingModel._parseDouble(json['amount']),
      paymentMethod: BookingModel._parseString(json['payment_method']),
      status: BookingModel._parseString(json['status']),
      transactionId: json['transaction_id'] != null
          ? BookingModel._parseString(json['transaction_id'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_id': paymentId,
      'amount': amount,
      'payment_method': paymentMethod,
      'status': status,
      'transaction_id': transactionId,
    };
  }
}

