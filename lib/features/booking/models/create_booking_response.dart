/// Create Booking Response
/// Response from POST /api/booking/park
class CreateBookingResponse {
  final bool status;
  final String message;
  final CreateBookingData? data;

  const CreateBookingResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? CreateBookingData.fromJson(json['data'] as Map<String, dynamic>)
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

class CreateBookingData {
  final int bookingId;
  final String startTime;
  final String endTime;
  final int hours;
  final double hourlyRate;
  final double totalAmount;
  final int remainingSpaces;

  const CreateBookingData({
    required this.bookingId,
    required this.startTime,
    required this.endTime,
    required this.hours,
    required this.hourlyRate,
    required this.totalAmount,
    required this.remainingSpaces,
  });

  factory CreateBookingData.fromJson(Map<String, dynamic> json) {
    // Helper function to parse double from int, double, or string
    double _parseDouble(dynamic value) {
      if (value is int) {
        return value.toDouble();
      } else if (value is double) {
        return value;
      } else if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return CreateBookingData(
      bookingId: json['booking_id'] as int,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      hours: json['hours'] as int,
      hourlyRate: _parseDouble(json['hourly_rate']),
      totalAmount: _parseDouble(json['total_amount']),
      remainingSpaces: json['remaining_spaces'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'start_time': startTime,
      'end_time': endTime,
      'hours': hours,
      'hourly_rate': hourlyRate,
      'total_amount': totalAmount,
      'remaining_spaces': remainingSpaces,
    };
  }
}

