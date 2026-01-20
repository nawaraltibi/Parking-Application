import '../models/create_parking_request.dart';
import '../models/create_parking_response.dart';
import '../models/parking_list_response.dart';
import '../models/update_parking_request.dart';
import '../models/update_parking_response.dart';
import '../models/owner_dashboard_stats_response.dart';
import '../../../core/utils/app_exception.dart';
import '../../../data/datasources/network/api_request.dart';

/// Parking Repository
/// Handles all owner parking management-related API calls
class ParkingRepository {
  /// Create a new parking lot
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 403: Unauthorized (not owner or account not active)
  /// - 422: Validation errors (duplicate lot_name/address, invalid coordinates, etc.)
  /// - 500: Server errors
  /// 
  /// Note: Created parking starts with:
  /// - status = 'inactive'
  /// - statusrequest = 'pending'
  /// Admin approval is required before parking becomes active.
  static Future<CreateParkingResponse> createParking({
    required CreateParkingRequest createRequest,
  }) async {
    final request = APIRequest(
      path: '/owner/parking/create',
      method: HTTPMethod.post,
      body: createRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      // Handle successful response (201 Created)
      if (response.statusCode == 201 && responseData is Map<String, dynamic>) {
        return CreateParkingResponse.fromJson(responseData);
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

  /// Get all parking lots belonging to the authenticated owner
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 403: Unauthorized (not owner or account not active)
  /// - 500: Server errors
  /// 
  /// Returns list of all parkings (pending, active, rejected) for the owner
  static Future<ParkingListResponse> getOwnerParkings() async {
    final request = APIRequest(
      path: '/owner/parking/data',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      // Handle successful response (201 OK - backend returns 201)
      if (response.statusCode == 201 && responseData is Map<String, dynamic>) {
        return ParkingListResponse.fromJson(responseData);
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

  /// Update an existing parking lot
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 403: Unauthorized (not owner or account not active)
  /// - 404: Parking lot not found or doesn't belong to owner
  /// - 422: Validation errors (duplicate lot_name/address, invalid coordinates, etc.)
  /// - 500: Server errors
  /// 
  /// Note: Updated parking automatically sets status = 'inactive'
  /// and requires admin approval again.
  static Future<UpdateParkingResponse> updateParking({
    required int parkingId,
    required UpdateParkingRequest updateRequest,
  }) async {
    final request = APIRequest(
      path: '/owner/parking/update/$parkingId',
      method: HTTPMethod.put,
      body: updateRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      // Handle successful response (200 OK)
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return UpdateParkingResponse.fromJson(responseData);
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

  /// Get owner dashboard statistics
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 403: Unauthorized (not owner or account not active)
  /// - 500: Server errors
  /// 
  /// Returns comprehensive statistics including:
  /// - Parking summary (total, active, pending, rejected)
  /// - Occupancy stats (spaces, occupancy rate)
  /// - Financial stats (revenue, payments)
  /// - Booking stats (total, active, cancelled)
  static Future<OwnerDashboardStatsResponse> getOwnerDashboardStats() async {
    final request = APIRequest(
      path: '/owner/alldataofinvestor',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      
      final responseData = response.data;
      
      // Handle successful response (200 OK)
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return OwnerDashboardStatsResponse.fromJson(responseData);
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

