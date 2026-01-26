import 'booking_model.dart';

/// Bookings List Response
/// Response from GET /api/booking/active
/// and GET /api/booking/finished
class BookingsListResponse {
  final bool status;
  final String message;
  final List<BookingModel>? data;

  const BookingsListResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BookingsListResponse.fromJson(Map<String, dynamic> json) {
    List<BookingModel>? bookingsList;
    
    if (json['data'] != null && json['data'] is List) {
      bookingsList = (json['data'] as List)
          .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return BookingsListResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: bookingsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (data != null) 'data': data!.map((booking) => booking.toJson()).toList(),
    };
  }

  /// Check if there are any bookings
  bool get hasBookings => data != null && data!.isNotEmpty;

  /// Get count of bookings
  int get bookingsCount => data?.length ?? 0;
}

