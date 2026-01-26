import 'booking_model.dart';

/// Booking Details Response
/// Response from GET /api/booking/getdetails/{bookingId}
class BookingDetailsResponse {
  final bool status;
  final String? message;
  final BookingModel? data;

  const BookingDetailsResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory BookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? BookingModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (message != null) 'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

