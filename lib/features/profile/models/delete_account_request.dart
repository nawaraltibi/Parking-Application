/// Delete Account Request Model
/// Request body for POST /api/profile/delete endpoint
class DeleteAccountRequest {
  final String password;

  DeleteAccountRequest({
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }

  /// Validate request fields
  List<String> validate() {
    final errors = <String>[];
    
    if (password.isEmpty) {
      errors.add('Password is required');
    }
    
    return errors;
  }
}

