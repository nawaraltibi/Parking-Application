import 'dart:convert';
import 'storage_service.dart';
import '../../features/profile/models/profile_data_response.dart';

/// Profile Cache Service
/// Manages local caching of user profile data using SharedPreferences
/// 
/// Features:
/// - Stores profile data locally for instant loading
/// - Automatically updates cache when profile is updated
/// - Provides fallback when API is unavailable
class ProfileCacheService {
  static const String _profileCacheKey = 'cached_profile_data';

  /// Save profile data to cache
  static Future<bool> saveProfile(ProfileDataResponse profileData) async {
    try {
      final jsonString = json.encode(profileData.toJson());
      return await StorageService.setString(_profileCacheKey, jsonString);
    } catch (e) {
      return false;
    }
  }

  /// Get cached profile data
  /// Returns null if no cached data exists
  static ProfileDataResponse? getCachedProfile() {
    try {
      final jsonString = StorageService.getString(_profileCacheKey);
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return ProfileDataResponse.fromJson(jsonData);
    } catch (e) {
      return null;
    }
  }

  /// Clear cached profile data
  static Future<bool> clearCache() async {
    return await StorageService.remove(_profileCacheKey);
  }

  /// Check if cached profile exists
  static bool hasCachedProfile() {
    return StorageService.containsKey(_profileCacheKey);
  }
}

