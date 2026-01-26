/// Cancel Booking Response
/// Response from POST /api/booking/{bookingId}/cancel
class CancelBookingResponse {
  final bool status;
  final String message;
  final CancelBookingData? data;

  const CancelBookingResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CancelBookingResponse.fromJson(Map<String, dynamic> json) {
    return CancelBookingResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? CancelBookingData.fromJson(json['data'] as Map<String, dynamic>)
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

class CancelBookingData {
  final int bookingId;
  final String status;
  final String cancelledAt;

  const CancelBookingData({
    required this.bookingId,
    required this.status,
    required this.cancelledAt,
  });

  factory CancelBookingData.fromJson(Map<String, dynamic> json) {
    return CancelBookingData(
      bookingId: json['booking_id'] as int,
      status: json['status'] as String,
      cancelledAt: json['cancelled_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'status': status,
      'cancelled_at': cancelledAt,
    };
  }
}

