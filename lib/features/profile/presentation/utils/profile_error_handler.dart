import '../../../../core/utils/app_exception.dart';
import '../../../../l10n/app_localizations.dart';

/// Centralized error handling for profile feature
class ProfileErrorHandler {
  /// Formats error messages for display to users
  static String formatError(Object error, AppLocalizations l10n) {
    if (error is AppException) {
      // Handle specific status codes
      if (error.statusCode == 401) {
        return 'Unauthorized access';
      }
      
      if (error.statusCode == 404) {
        return 'Profile not found';
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
  
  /// Handles error state and formats message with profile-specific translations
  static String handleErrorState(
    String error,
    int statusCode,
    AppLocalizations l10n,
  ) {
    // Translate known error messages
    if (statusCode == 422) {
      if (error.contains('incorrect password') ||
          error.contains('Incorrect password')) {
        return l10n.profileErrorIncorrectPassword;
      } else if (error.contains('Passwords do not match') ||
          error.contains('password mismatch')) {
        return l10n.profileErrorPasswordMismatch;
      } else if ((error.contains('email') && error.contains('already')) ||
          error.contains('taken')) {
        return l10n.profileErrorEmailExists;
      }
    }
    
    return formatError(
      AppException(
        statusCode: statusCode,
        errorCode: 'profile-error',
        message: error,
      ),
      l10n,
    );
  }
}

