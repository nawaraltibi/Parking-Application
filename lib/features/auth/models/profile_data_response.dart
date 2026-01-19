import 'user_model.dart';

/// Profile Data Response Model
/// Response from GET /api/profile/data endpoint
class ProfileDataResponse {
  final String message;
  final ProfileData data;

  ProfileDataResponse({
    required this.message,
    required this.data,
  });

  factory ProfileDataResponse.fromJson(Map<String, dynamic> json) {
    return ProfileDataResponse(
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ProfileData.fromJson(json['data'] as Map<String, dynamic>)
          : throw Exception('Data is required in profile response'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Profile Data Model
/// Contains user profile information
class ProfileData {
  final String fullName;
  final String email;
  final String phone;
  final String userType;
  final int numberOfVehicles;
  final String status;

  ProfileData({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.numberOfVehicles,
    required this.status,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      userType: json['user_type'] as String? ?? '',
      numberOfVehicles: _parseInt(json['number of vehicle'] ?? json['number_of_vehicles'] ?? 0),
      status: json['status'] as String? ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'user_type': userType,
      'number of vehicle': numberOfVehicles,
      'status': status,
    };
  }

  /// Convert to UserModel for consistency
  UserModel toUserModel({int? userId}) {
    return UserModel(
      userId: userId ?? 0,
      fullName: fullName,
      email: email,
      phone: phone,
      userType: userType,
      status: status,
    );
  }
}

