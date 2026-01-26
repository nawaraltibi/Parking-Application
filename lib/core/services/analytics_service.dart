/// Analytics Service Interface
/// 
/// Abstract interface for analytics services (Firebase, Mixpanel, etc.)
/// Allows swapping analytics providers without changing Bloc Observer
abstract class AnalyticsService {
  /// Log an event with optional parameters
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  });

  /// Set user properties
  Future<void> setUserProperty({
    required String name,
    required String value,
  });

  /// Set user ID
  Future<void> setUserId(String userId);

  /// Log screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  });
}

/// Firebase Analytics Implementation
/// Uncomment and implement when Firebase is added
/// 
/// Example:
/// ```dart
/// class FirebaseAnalyticsService implements AnalyticsService {
///   final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
/// 
///   @override
///   Future<void> logEvent({
///     required String name,
///     Map<String, dynamic>? parameters,
///   }) async {
///     await _analytics.logEvent(
///       name: name,
///       parameters: parameters,
///     );
///   }
/// 
///   @override
///   Future<void> setUserProperty({
///     required String name,
///     required String value,
///   }) async {
///     await _analytics.setUserProperty(
///       name: name,
///       value: value,
///     );
///   }
/// 
///   @override
///   Future<void> setUserId(String userId) async {
///     await _analytics.setUserId(id: userId);
///   }
/// 
///   @override
///   Future<void> logScreenView({
///     required String screenName,
///     String? screenClass,
///   }) async {
///     await _analytics.logScreenView(
///       screenName: screenName,
///       screenClass: screenClass,
///     );
///   }
/// }
/// ```

/// Mock Analytics Service for Development/Testing
class MockAnalyticsService implements AnalyticsService {
  final List<Map<String, dynamic>> _events = [];

  @override
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    _events.add({
      'name': name,
      'parameters': parameters,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print('📊 [MockAnalytics] Event: $name');
    if (parameters != null) {
      print('   Parameters: $parameters');
    }
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    print('📊 [MockAnalytics] User Property: $name = $value');
  }

  @override
  Future<void> setUserId(String userId) async {
    print('📊 [MockAnalytics] User ID: $userId');
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    print('📊 [MockAnalytics] Screen View: $screenName');
  }

  /// Get all logged events (for testing)
  List<Map<String, dynamic>> get events => List.unmodifiable(_events);

  /// Clear all logged events (for testing)
  void clearEvents() => _events.clear();
}

