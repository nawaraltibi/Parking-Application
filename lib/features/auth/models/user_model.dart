/// User Model
/// Represents a user in the Parking Application system
class UserModel {
  final int userId;
  final String fullName;
  final String email;
  final String phone;
  final String userType; // 'user', 'owner', or 'admin'
  final String status; // 'active' or 'inactive'
  final String? createdAt;
  final String? updatedAt;

  const UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  /// Helper method to safely convert dynamic value to int
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  /// Helper method to safely convert dynamic value to String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: _parseInt(json['user_id'] ?? json['id']),
      fullName: _parseString(json['full_name']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      userType: _parseString(json['user_type']),
      status: _parseString(json['status']),
      createdAt: _parseString(json['created_at'], defaultValue: ''),
      updatedAt: _parseString(json['updated_at'], defaultValue: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    int? userId,
    String? fullName,
    String? email,
    String? phone,
    String? userType,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      userType: userType ?? this.userType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if user is active
  bool get isActive => status == 'active';

  /// Check if user is inactive
  bool get isInactive => status == 'inactive';

  /// Check if user is owner
  bool get isOwner => userType == 'owner';

  /// Check if user is regular user
  bool get isRegularUser => userType == 'user';

  /// Check if user is admin
  bool get isAdmin => userType == 'admin';
}

