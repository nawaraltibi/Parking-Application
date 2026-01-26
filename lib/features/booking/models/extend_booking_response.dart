/// Extend Booking Response
/// Response from POST /api/booking/extendbooking/{bookingId}
class ExtendBookingResponse {
  final bool status;
  final String message;
  final ExtendBookingData? data;

  const ExtendBookingResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ExtendBookingResponse.fromJson(Map<String, dynamic> json) {
    return ExtendBookingResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ExtendBookingData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class ExtendBookingData {
  final int bookingId;
  final int requestedExtraHours;
  final double totalAmount;

  const ExtendBookingData({
    required this.bookingId,
    required this.requestedExtraHours,
    required this.totalAmount,
  });

  factory ExtendBookingData.fromJson(Map<String, dynamic> json) {
    return ExtendBookingData(
      bookingId: json['booking_id'] as int,
      requestedExtraHours: json['requested_extra_hours'] as int,
      totalAmount: (json['totalAmount'] is int)
          ? (json['totalAmount'] as int).toDouble()
          : json['totalAmount'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'requested_extra_hours': requestedExtraHours,
      'totalAmount': totalAmount,
    };
  }
}

