import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/analytics_service.dart';

/// Global Bloc Observer
/// Monitors all Bloc events, state transitions, and errors across the app
/// 
/// Features:
/// - Logs all events and state transitions
/// - Logs errors with stack traces
/// - Sends event analytics to analytics service
/// - Development-friendly logging format
class AppBlocObserver extends BlocObserver {
  final AnalyticsService? analyticsService;

  AppBlocObserver({this.analyticsService});

  /// Called whenever an event is added to any Bloc
  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    
    // Log event to console
    _logEvent(bloc, event);
    
    // Send to analytics if service is available
    if (event != null && analyticsService != null) {
      sendEventAnalytics(bloc, event);
    }
  }

  /// Called whenever a state transition occurs in any Bloc
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    
    // Log transition to console
    _logTransition(bloc, transition);
  }

  /// Called whenever an error occurs in any Bloc
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    
    // Log error with stack trace
    _logError(bloc, error, stackTrace);
    
    // Send error to analytics if service is available
    if (analyticsService != null) {
      sendErrorAnalytics(bloc, error, stackTrace);
    }
  }

  /// Log event to console with formatted output
  void _logEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    developer.log(
      '📤 EVENT',
      name: 'BlocObserver',
      error: '''
┌─────────────────────────────────────────────────────────────
│ 🎯 Bloc: ${bloc.runtimeType}
│ 📤 Event: ${event.runtimeType}
│ 📝 Details: $event
└─────────────────────────────────────────────────────────────''',
    );
  }

  /// Log state transition to console with formatted output
  void _logTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    developer.log(
      '🔄 TRANSITION',
      name: 'BlocObserver',
      error: '''
┌─────────────────────────────────────────────────────────────
│ 🎯 Bloc: ${bloc.runtimeType}
│ 🔄 Transition:
│   Current:  ${transition.currentState.runtimeType}
│   Event:    ${transition.event.runtimeType}
│   Next:     ${transition.nextState.runtimeType}
└─────────────────────────────────────────────────────────────''',
    );
  }

  /// Log error with stack trace to console
  void _logError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      '❌ ERROR',
      name: 'BlocObserver',
      error: '''
┌─────────────────────────────────────────────────────────────
│ 🎯 Bloc: ${bloc.runtimeType}
│ ❌ Error: ${error.runtimeType}
│ 📝 Message: $error
│ 📍 Stack Trace:
$stackTrace
└─────────────────────────────────────────────────────────────''',
      stackTrace: stackTrace,
    );
  }

  /// Send event analytics to analytics service
  /// 
  /// Automatically tracks:
  /// - Event name
  /// - Bloc type
  /// - Timestamp
  /// - Event details (serialized if possible)
  void sendEventAnalytics(Bloc<dynamic, dynamic> bloc, Object event) {
    try {
      final eventName = event.runtimeType.toString();
      final blocType = bloc.runtimeType.toString();
      final timestamp = DateTime.now();

      analyticsService?.logEvent(
        name: 'bloc_event',
        parameters: {
          'event_name': eventName,
          'bloc_type': blocType,
          'timestamp': timestamp.toIso8601String(),
          'event_details': event.toString(),
        },
      );

      developer.log(
        '📊 Analytics sent: $eventName in $blocType',
        name: 'BlocObserver',
      );
    } catch (e) {
      // Silently fail - don't break app flow for analytics
      developer.log(
        '⚠️ Failed to send analytics: $e',
        name: 'BlocObserver',
      );
    }
  }

  /// Send error analytics to analytics service
  /// 
  /// Tracks errors for monitoring and debugging
  void sendErrorAnalytics(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    try {
      final blocType = bloc.runtimeType.toString();
      final errorType = error.runtimeType.toString();
      final timestamp = DateTime.now();

      analyticsService?.logEvent(
        name: 'bloc_error',
        parameters: {
          'bloc_type': blocType,
          'error_type': errorType,
          'error_message': error.toString(),
          'timestamp': timestamp.toIso8601String(),
          // Don't send full stack trace to analytics (too large)
          'has_stack_trace': true,
        },
      );
    } catch (e) {
      // Silently fail - don't break app flow for analytics
      developer.log(
        '⚠️ Failed to send error analytics: $e',
        name: 'BlocObserver',
      );
    }
  }

  /// Helper method to enable/disable verbose logging
  /// Can be toggled based on build mode (debug/release)
  static bool isVerboseLoggingEnabled = true;
}

