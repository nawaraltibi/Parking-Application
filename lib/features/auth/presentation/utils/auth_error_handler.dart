import '../../../../core/utils/app_exception.dart';
import '../../../../l10n/app_localizations.dart';

/// Centralized error handling for auth feature
class AuthErrorHandler {
  /// Formats error messages for display to users
  static String formatError(Object error, AppLocalizations l10n) {
    if (error is AppException) {
      // Handle specific status codes
      if (error.statusCode == 401) {
        return l10n.authErrorInvalidCredentials;
      }
      
      // Handle validation errors
      if (error.errors != null && error.errors!.isNotEmpty) {
        return error.errors!.values
            .expand((errors) => errors)
            .join('\n');
      }
      
      return error.message;
    }
    
    return error.toString();
  }
  
  /// Handles login error state and formats message with auth-specific translations
  static String handleLoginError(
    String error,
    int statusCode,
    AppLocalizations l10n,
  ) {
    // Map known error messages to localized strings
    if (statusCode == 401) {
      return l10n.authErrorInvalidCredentials;
    }
    if (error.contains('Invalid Email or Password') || 
        error.toLowerCase().contains('invalid credentials')) {
      return l10n.authErrorInvalidCredentials;
    }
    if (error.contains('Your account is pending admin approval')) {
      return l10n.authErrorAccountPending;
    }
    if (error.contains('Your account has been blocked')) {
      return l10n.authErrorAccountBlocked;
    }
    
    // Return original error message if not recognized
    return formatError(
      AppException(
        statusCode: statusCode,
        errorCode: 'auth-error',
        message: error,
      ),
      l10n,
    );
  }
  
  /// Handles register error state
  static String handleRegisterError(
    String error,
    int statusCode,
    AppLocalizations l10n,
  ) {
    // Most validation errors from API should already be in the error message
    return formatError(
      AppException(
        statusCode: statusCode,
        errorCode: 'auth-error',
        message: error,
      ),
      l10n,
    );
  }
  
  /// Handles logout error state
  static String handleLogoutError(
    String error,
    int statusCode,
    AppLocalizations l10n,
  ) {
    if (statusCode == 401) {
      return l10n.authErrorUnauthenticated;
    }
    
    return formatError(
      AppException(
        statusCode: statusCode,
        errorCode: 'auth-error',
        message: error,
      ),
      l10n,
    );
  }
}

