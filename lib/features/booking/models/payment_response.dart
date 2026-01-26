/// Payment Response
/// Response from POST /api/booking/paymentsuccess/{bookingId}
/// and POST /api/booking/paymentfailed/{bookingId}
class PaymentResponse {
  final bool status;
  final String message;
  final PaymentData? data;

  const PaymentResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? PaymentData.fromJson(json['data'] as Map<String, dynamic>)
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

class PaymentData {
  final int bookingId;
  final String? newEndTime;
  final int paymentId;

  const PaymentData({
    required this.bookingId,
    this.newEndTime,
    required this.paymentId,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      bookingId: json['booking_id'] as int,
      newEndTime: json['new_end_time'] as String?,
      paymentId: json['payment_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      if (newEndTime != null) 'new_end_time': newEndTime,
      'payment_id': paymentId,
    };
  }
}

