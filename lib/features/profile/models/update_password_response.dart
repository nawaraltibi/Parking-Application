/// Update Password Response Model
/// Response from PUT /api/updatepassword endpoint
class UpdatePasswordResponse {
  final String message;

  UpdatePasswordResponse({
    required this.message,
  });

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return UpdatePasswordResponse(
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

