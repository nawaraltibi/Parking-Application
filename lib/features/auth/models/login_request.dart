/// Login Request Model
/// Request body for user login
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    this.email = '',
    this.password = '',
  });

  /// Create a copy of LoginRequest with updated fields
  LoginRequest copyWith({
    String? email,
    String? password,
  }) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  /// Validate request data
  /// Returns list of validation error messages
  List<String> validate() {
    final errors = <String>[];

    if (email.trim().isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(email)) {
      errors.add('Email must be a valid email address');
    }

    if (password.isEmpty) {
      errors.add('Password is required');
    } else if (password.length < 8) {
      errors.add('Password must be at least 8 characters');
    }

    return errors;
  }

  /// Check if email is valid
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

