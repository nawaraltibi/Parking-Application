import '../../../../core/utils/app_exception.dart';
import '../../../../l10n/app_localizations.dart';

/// Centralized error handling for parking feature
class ParkingErrorHandler {
  /// Formats error messages for display to users
  static String formatError(Object error, AppLocalizations l10n) {
    if (error is AppException) {
      // Handle specific status codes
      if (error.statusCode == 403) {
        return l10n.parkingErrorUnauthorized;
      }
      
      if (error.statusCode == 404) {
        return l10n.parkingErrorNotFound;
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
  
  /// Handles error state and formats message
  static String handleErrorState(
    String error,
    int statusCode,
    AppLocalizations l10n,
  ) {
    return formatError(
      AppException(
        statusCode: statusCode,
        errorCode: 'parking-error',
        message: error,
      ),
      l10n,
    );
  }
}

