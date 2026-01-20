/// Update Password Request Model
/// Request body for PUT /api/updatepassword endpoint
class UpdatePasswordRequest {
  final String password; // Current password
  final String newPassword;
  final String newPasswordConfirmation;

  UpdatePasswordRequest({
    required this.password,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
      'newpassword': newPassword,
      'newpassword_confirmation': newPasswordConfirmation,
    };
  }

  /// Validate request fields
  List<String> validate() {
    final errors = <String>[];
    
    if (password.isEmpty) {
      errors.add('Current password is required');
    }
    
    if (newPassword.isEmpty) {
      errors.add('New password is required');
    } else if (newPassword.length < 8) {
      errors.add('New password must be at least 8 characters');
    }
    
    if (newPasswordConfirmation.isEmpty) {
      errors.add('Password confirmation is required');
    } else if (newPassword != newPasswordConfirmation) {
      errors.add('Passwords do not match');
    }
    
    return errors;
  }
}

