import 'user_model.dart';

/// Update Profile Response Model
/// Response from PUT /api/profile/update endpoint
class UpdateProfileResponse {
  final String message;
  final UserModel user;

  UpdateProfileResponse({
    required this.message,
    required this.user,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      message: json['message'] as String? ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : throw Exception('User data is required in update profile response'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

