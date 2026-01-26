/// Remaining Time Response
/// Response from GET /api/booking/remainingtime/{bookingId}
class RemainingTimeResponse {
  final bool status;
  final String? message;
  final int? bookingId;
  final int? remainingSeconds;
  final String? remainingTime; // Formatted as HH:MM:SS
  final String? warning;

  const RemainingTimeResponse({
    required this.status,
    this.message,
    this.bookingId,
    this.remainingSeconds,
    this.remainingTime,
    this.warning,
  });

  factory RemainingTimeResponse.fromJson(Map<String, dynamic> json) {
    return RemainingTimeResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String?,
      bookingId: json['booking_id'] as int?,
      remainingSeconds: json['remaining_seconds'] as int?,
      remainingTime: json['remaining_time'] as String?,
      warning: json['warning'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (message != null) 'message': message,
      if (bookingId != null) 'booking_id': bookingId,
      if (remainingSeconds != null) 'remaining_seconds': remainingSeconds,
      if (remainingTime != null) 'remaining_time': remainingTime,
      if (warning != null) 'warning': warning,
    };
  }

  /// Check if there's a warning (less than 10 minutes remaining)
  bool get hasWarning => warning != null && warning!.isNotEmpty;

  /// Check if time has expired
  bool get hasExpired => remainingSeconds != null && remainingSeconds! <= 0;
}

