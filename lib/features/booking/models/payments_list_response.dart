import 'booking_model.dart';

/// Payment Model (for list)
class PaymentModel {
  final int paymentId;
  final double amount;
  final String paymentMethod;
  final String status;
  final String? transactionId;
  final int bookingId;
  final int userId;
  final String? createdAt;
  final String? updatedAt;
  final BookingModel? booking;

  const PaymentModel({
    required this.paymentId,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    this.transactionId,
    required this.bookingId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
    this.booking,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      paymentId: json['payment_id'] as int,
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : json['amount'] as double,
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      transactionId: json['transaction_id'] as String?,
      bookingId: json['booking_id'] as int,
      userId: json['user_id'] as int,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      booking: json['booking'] != null
          ? BookingModel.fromJson(json['booking'] as Map<String, dynamic>)
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
      'booking_id': bookingId,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (booking != null) 'booking': booking!.toJson(),
    };
  }

  /// Check if payment was successful
  bool get isSuccess => status == 'success';

  /// Check if payment failed
  bool get isFailed => status == 'failed';
}

/// Payments List Response
/// Response from GET /api/booking/allpayments
class PaymentsListResponse {
  final bool status;
  final String message;
  final List<PaymentModel>? data;

  const PaymentsListResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentsListResponse.fromJson(Map<String, dynamic> json) {
    List<PaymentModel>? paymentsList;
    
    if (json['data'] != null && json['data'] is List) {
      paymentsList = (json['data'] as List)
          .map((item) => PaymentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return PaymentsListResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: paymentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.map((payment) => payment.toJson()).toList(),
    };
  }

  /// Check if there are any payments
  bool get hasPayments => data != null && data!.isNotEmpty;

  /// Get count of payments
  int get paymentsCount => data?.length ?? 0;
}

