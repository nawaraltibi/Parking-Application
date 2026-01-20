/// Update Profile Request Model
/// Request body for PUT /api/profile/update endpoint
class UpdateProfileRequest {
  final String fullName;
  final String email;
  final String phone;

  UpdateProfileRequest({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
    };
  }

  /// Validate request fields
  List<String> validate() {
    final errors = <String>[];
    
    if (fullName.trim().isEmpty) {
      errors.add('Full name is required');
    }
    
    if (email.trim().isEmpty) {
      errors.add('Email is required');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors.add('Invalid email format');
    }
    
    if (phone.trim().isEmpty) {
      errors.add('Phone is required');
    }
    
    return errors;
  }

  /// Create a copy with updated fields
  UpdateProfileRequest copyWith({
    String? fullName,
    String? email,
    String? phone,
  }) {
    return UpdateProfileRequest(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}

