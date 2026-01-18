import 'user_model.dart';

/// Login Response Model
/// Response from login API
class LoginResponse {
  final String message;
  final UserModel user;
  final String token;
  final String userType;

  LoginResponse({
    required this.message,
    required this.user,
    required this.token,
    required this.userType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String? ?? '',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : throw Exception('User data is required in login response'),
      token: json['token'] as String? ?? '',
      userType: json['user_type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'token': token,
      'user_type': userType,
    };
  }

  /// Check if user is active
  bool get isActive => user.isActive;

  /// Check if user is inactive
  bool get isInactive => user.isInactive;

  /// Check if user is owner
  bool get isOwner => user.isOwner;

  /// Check if user is regular user
  bool get isRegularUser => user.isRegularUser;

  /// Check if user is admin
  bool get isAdmin => user.isAdmin;

  /// Get status message based on user status and type
  /// Returns appropriate message for inactive users
  String? getStatusMessage() {
    if (isInactive) {
      if (isOwner) {
        return 'Your account is pending admin approval';
      } else if (isRegularUser) {
        return 'Your account has been blocked. Please contact support';
      }
    }
    return null;
  }
}

