/// Extend Booking Request
/// Request body for extending an existing booking
class ExtendBookingRequest {
  final int extraHours;

  const ExtendBookingRequest({
    required this.extraHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'extra_hours': extraHours,
    };
  }

  factory ExtendBookingRequest.fromJson(Map<String, dynamic> json) {
    return ExtendBookingRequest(
      extraHours: json['extra_hours'] as int,
    );
  }
}

