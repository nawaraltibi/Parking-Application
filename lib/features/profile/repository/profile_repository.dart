import '../models/profile_data_response.dart';
import '../models/update_profile_request.dart';
import '../models/update_profile_response.dart';
import '../models/update_password_request.dart';
import '../models/update_password_response.dart';
import '../models/delete_account_request.dart';
import '../models/delete_account_response.dart';
import '../../../core/utils/app_exception.dart';
import '../../../data/datasources/network/api_request.dart';

/// Profile Repository
/// Handles all profile-related API calls
class ProfileRepository {
  /// Get user profile data
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  static Future<ProfileDataResponse> getProfile() async {
    final request = APIRequest(
      path: '/profile/data',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      if (response.statusCode == 201 && responseData is Map<String, dynamic>) {
        return ProfileDataResponse.fromJson(responseData);
      }
      
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Update user profile
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 404: User not found
  /// - 422: Validation errors (duplicate email, etc.)
  /// - 500: Server errors
  static Future<UpdateProfileResponse> updateProfile({
    required UpdateProfileRequest updateRequest,
  }) async {
    final request = APIRequest(
      path: '/profile/update',
      method: HTTPMethod.put,
      body: updateRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return UpdateProfileResponse.fromJson(responseData);
      }
      
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Update user password
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 422: Validation errors (incorrect password, password mismatch, etc.)
  /// - 500: Server errors
  /// 
  /// Note: This endpoint invalidates all existing tokens
  static Future<UpdatePasswordResponse> updatePassword({
    required UpdatePasswordRequest updateRequest,
  }) async {
    final request = APIRequest(
      path: '/updatepassword',
      method: HTTPMethod.put,
      body: updateRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return UpdatePasswordResponse.fromJson(responseData);
      }
      
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Delete user account
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 422: Validation errors (incorrect password)
  /// - 500: Server errors
  static Future<DeleteAccountResponse> deleteAccount({
    required DeleteAccountRequest deleteRequest,
  }) async {
    final request = APIRequest(
      path: '/profile/delete',
      method: HTTPMethod.post,
      body: deleteRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return DeleteAccountResponse.fromJson(responseData);
      }
      
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }
}

