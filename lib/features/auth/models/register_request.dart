/// Register Request Model
/// Request body for user registration
class RegisterRequest {
  final String fullName;
  final String email;
  final String phone;
  final String userType; // 'user' or 'owner'
  final String password;
  final String passwordConfirmation;

  RegisterRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.password,
    required this.passwordConfirmation,
  });

  /// Create a copy of RegisterRequest with updated fields
  RegisterRequest copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? userType,
    String? password,
    String? passwordConfirmation,
  }) {
    return RegisterRequest(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }

  /// Validate request data
  /// Returns list of validation error messages
  List<String> validate() {
    final errors = <String>[];

    if (fullName.trim().isEmpty) {
      errors.add('Full name is required');
    } else if (fullName.length > 255) {
      errors.add('Full name must not exceed 255 characters');
    }

    if (email.trim().isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Email must be a valid email address');
    }

    if (phone.trim().isEmpty) {
      errors.add('Phone is required');
    }

    if (userType.trim().isEmpty) {
      errors.add('User type is required');
    } else if (userType != 'user' && userType != 'owner') {
      errors.add('User type must be either "user" or "owner"');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    } else if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }

    if (passwordConfirmation.isEmpty) {
      errors.add('Password confirmation is required');
    } else if (password != passwordConfirmation) {
      errors.add('Password confirmation does not match');
    }

    return errors;
  }

  /// Check if email is valid
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

