/// Delete Account Response Model
/// Response from POST /api/profile/delete endpoint
class DeleteAccountResponse {
  final String message;

  DeleteAccountResponse({
    required this.message,
  });

  factory DeleteAccountResponse.fromJson(Map<String, dynamic> json) {
    return DeleteAccountResponse(
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

