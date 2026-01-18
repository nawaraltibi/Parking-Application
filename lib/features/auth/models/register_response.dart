import 'user_model.dart';

/// Register Response Model
/// Response from registration API
class RegisterResponse {
  final String message;
  final UserModel user;

  RegisterResponse({
    required this.message,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] as String? ?? '',
      user: json['User'] != null
          ? UserModel.fromJson(json['User'] as Map<String, dynamic>)
          : throw Exception('User data is required in registration response'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'User': user.toJson(),
    };
  }

  /// Check if registration was successful and user is active
  bool get isActive => user.isActive;

  /// Check if registration requires admin approval (owner registration)
  bool get requiresApproval => user.isInactive && user.isOwner;
}

