import '../models/register_request.dart';
import '../models/register_response.dart';
import '../../../core/utils/app_exception.dart';
import '../../../data/datasources/network/api_request.dart';

/// Auth Repository
/// Handles all authentication-related API calls
class AuthRepository {
  /// Register a new user
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 422: Validation errors (duplicate email, password mismatch, etc.)
  /// - 500: Server errors
  static Future<RegisterResponse> register({
    required RegisterRequest registerRequest,
  }) async {
    final request = APIRequest(
      path: '/register',
      method: HTTPMethod.post,
      body: registerRequest.toJson(),
      authorizationOption: AuthorizationOption.unauthorized,
    );

    try {
      final response = await request.send();
      
      // DioProvider returns Response object, extract data
      final responseData = response.data;
      
      // Handle successful response (201 Created)
      if (response.statusCode == 201 && responseData is Map<String, dynamic>) {
        return RegisterResponse.fromJson(responseData);
      }
      
      // If we get here, something unexpected happened
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      // Re-throw AppException as-is (it contains proper error details)
      rethrow;
    } catch (e) {
      // Wrap unexpected errors
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }
}

