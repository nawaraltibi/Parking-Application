// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Parking Application';

  @override
  String get onboardingTitle1 => 'Discover nearby parking easily';

  @override
  String get onboardingDescription1 =>
      'Find available parking spots near you with real-time availability and convenient locations.';

  @override
  String get onboardingTitle2 => 'Reserve your parking spot in seconds';

  @override
  String get onboardingDescription2 =>
      'Book your parking space instantly and secure your spot before you arrive. No more circling around!';

  @override
  String get onboardingTitle3 => 'Manage and monetize your parking';

  @override
  String get onboardingDescription3 =>
      'Parking owners can easily manage spaces, set pricing, and earn income from unused parking spots.';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get authLoginTitle => 'Welcome Back';

  @override
  String get authLoginSubtitle => 'Sign in to continue using the parking app';

  @override
  String get authLoginButton => 'Login';

  @override
  String get authRegisterTitle => 'Create Account';

  @override
  String get authRegisterSubtitle => 'Sign up to start using the parking app';

  @override
  String get authRegisterButton => 'Register';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'Enter your email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authPasswordRegisterHint =>
      'Enter your password (min 8 characters)';

  @override
  String get authFullNameLabel => 'Full Name';

  @override
  String get authFullNameHint => 'Enter your full name';

  @override
  String get authPhoneLabel => 'Phone';

  @override
  String get authPhoneHint => 'Enter your phone number';

  @override
  String get authUserTypeLabel => 'User Type';

  @override
  String get authUserTypeRegular => 'Regular User';

  @override
  String get authUserTypeOwner => 'Parking Owner';

  @override
  String get authConfirmPasswordLabel => 'Confirm Password';

  @override
  String get authConfirmPasswordHint => 'Re-enter your password';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authValidationEmailRequired => 'Email is required';

  @override
  String get authValidationEmailInvalid => 'Please enter a valid email address';

  @override
  String get authValidationPasswordRequired => 'Password is required';

  @override
  String get authValidationPasswordShort =>
      'Password must be at least 8 characters';

  @override
  String get authValidationFullNameRequired => 'Full name is required';

  @override
  String get authValidationFullNameLong =>
      'Full name must not exceed 255 characters';

  @override
  String get authValidationPhoneRequired => 'Phone is required';

  @override
  String get authValidationUserTypeRequired => 'User type is required';

  @override
  String get authValidationUserTypeInvalid =>
      'User type must be either \"user\" or \"owner\"';

  @override
  String get authValidationPasswordConfirmationRequired =>
      'Password confirmation is required';

  @override
  String get authValidationPasswordMismatch =>
      'Password confirmation does not match';

  @override
  String get authErrorInvalidCredentials => 'Invalid Email or Password';

  @override
  String get authErrorUnexpected =>
      'An unexpected error occurred. Please try again.';

  @override
  String get authErrorUnauthenticated => 'Unauthenticated.';

  @override
  String get authErrorAccountPending =>
      'Your account is pending admin approval';

  @override
  String get authErrorOwnerPendingApproval =>
      'Your account is pending admin approval. Please wait until your account is activated.';

  @override
  String get authErrorAccountBlocked =>
      'Your account has been blocked. Please contact support';

  @override
  String get authSuccessRegisterPending =>
      'Your account is pending admin approval. You will be notified once approved.';

  @override
  String get authSuccessLogout => 'Logged out successfully';

  @override
  String get authProfileTitle => 'Profile';

  @override
  String get authLogoutButton => 'Logout';

  @override
  String get authLogoutDialogTitle => 'Logout';

  @override
  String get authLogoutDialogMessage => 'Are you sure you want to logout?';

  @override
  String get authLogoutDialogCancel => 'Cancel';

  @override
  String get authLogoutDialogConfirm => 'Logout';

  @override
  String get ownerTabParkingManagement => 'Parking Management';

  @override
  String get ownerTabProfile => 'Profile';

  @override
  String get userTabHome => 'Home';

  @override
  String get userTabVehicles => 'Vehicles';

  @override
  String get userTabParkings => 'Bookings';

  @override
  String get userTabProfile => 'Profile';

  @override
  String get placeholderComingSoon => 'Coming soon';

  @override
  String get profileEditButton => 'Edit Profile';

  @override
  String get profileSaveButton => 'Save Changes';

  @override
  String get profileCancelButton => 'Cancel';

  @override
  String get profileUpdatePasswordButton => 'Update Password';

  @override
  String get profileDeleteAccountButton => 'Delete Account';

  @override
  String get profileNumberOfVehicles => 'Number of Vehicles';

  @override
  String get profileCurrentPasswordLabel => 'Current Password';

  @override
  String get profileCurrentPasswordHint => 'Enter your current password';

  @override
  String get profileNewPasswordLabel => 'New Password';

  @override
  String get profileNewPasswordHint =>
      'Enter your new password (min 8 characters)';

  @override
  String get profileConfirmNewPasswordLabel => 'Confirm New Password';

  @override
  String get profileConfirmNewPasswordHint => 'Re-enter your new password';

  @override
  String get profileDeleteAccountPasswordLabel => 'Password';

  @override
  String get profileDeleteAccountPasswordHint =>
      'Enter your password to confirm';

  @override
  String get profileUpdatePasswordDialogTitle => 'Update Password';

  @override
  String get profileDeleteAccountDialogTitle => 'Delete Account';

  @override
  String get profileDeleteAccountDialogMessage =>
      'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get profileDeleteAccountDialogConfirm => 'Delete';

  @override
  String get profileSuccessUpdate => 'Profile updated successfully';

  @override
  String get profileSuccessPasswordUpdate =>
      'Password updated successfully. Please login again.';

  @override
  String get profileSuccessDeleteAccount => 'Account deleted successfully';

  @override
  String get profileErrorIncorrectPassword => 'Incorrect password';

  @override
  String get profileErrorPasswordMismatch => 'Passwords do not match';

  @override
  String get profileErrorEmailExists => 'Email already exists';

  @override
  String get profileLoading => 'Loading profile...';

  @override
  String get profileRetryButton => 'Retry';

  @override
  String get profileChangeLanguageButton => 'Change Language';

  @override
  String get parkingTitle => 'My Parkings';

  @override
  String get parkingCreateTitle => 'Create Parking';

  @override
  String get parkingUpdateTitle => 'Update Parking';

  @override
  String get parkingDashboardTitle => 'Dashboard';

  @override
  String get parkingLotNameLabel => 'Lot Name';

  @override
  String get parkingLotNameHint => 'Enter parking lot name';

  @override
  String get parkingAddressLabel => 'Address';

  @override
  String get parkingAddressHint => 'Enter parking address';

  @override
  String get parkingLatitudeLabel => 'Latitude';

  @override
  String get parkingLatitudeHint => 'Enter latitude (-90 to 90)';

  @override
  String get parkingLongitudeLabel => 'Longitude';

  @override
  String get parkingLongitudeHint => 'Enter longitude (-180 to 180)';

  @override
  String get parkingSelectLocationLabel => 'Select Parking Location';

  @override
  String get parkingChooseLocationButton => 'Choose location on map';

  @override
  String get parkingLocationNotSelected => 'Location not selected';

  @override
  String get parkingMapScreenTitle => 'Select Parking Location';

  @override
  String get parkingConfirmLocationButton => 'Confirm Location';

  @override
  String get parkingLocationPermissionDenied =>
      'Location permission is required to select your current location';

  @override
  String get parkingLocationError =>
      'Unable to get your location. Please select a location on the map.';

  @override
  String get parkingTotalSpacesLabel => 'Total Spaces';

  @override
  String get parkingTotalSpacesHint => 'Enter total parking spaces';

  @override
  String get parkingHourlyRateLabel => 'Hourly Rate';

  @override
  String get parkingHourlyRateHint => 'Enter hourly rate';

  @override
  String get parkingCreateButton => 'Create Parking';

  @override
  String get parkingUpdateButton => 'Update Parking';

  @override
  String get parkingStatusPending => 'Pending';

  @override
  String get parkingStatusApproved => 'Approved';

  @override
  String get parkingStatusRejected => 'Rejected';

  @override
  String get parkingStatusActive => 'Active';

  @override
  String get parkingStatusInactive => 'Inactive';

  @override
  String get parkingEmptyState => 'No parking lots yet';

  @override
  String get parkingEmptyStateSubtitle =>
      'Create your first parking lot to get started';

  @override
  String get parkingUpdateRequiresApproval =>
      'Updating this parking will require admin approval again';

  @override
  String get parkingUpdateConfirmTitle => 'Confirm Update';

  @override
  String get parkingUpdateConfirmMessage =>
      'This update will be sent to admin for approval. Continue?';

  @override
  String get parkingSuccessCreate =>
      'Parking created successfully. Waiting for admin approval.';

  @override
  String get parkingSuccessUpdate =>
      'Parking update request submitted. Waiting for admin approval.';

  @override
  String get parkingErrorUnauthorized =>
      'You are not authorized to perform this action';

  @override
  String get parkingErrorNotFound => 'Parking lot not found';

  @override
  String get parkingRetryButton => 'Retry';

  @override
  String get parkingLoading => 'Loading parkings...';

  @override
  String get parkingCreating => 'Creating parking...';

  @override
  String get parkingUpdating => 'Updating parking...';

  @override
  String get parkingDashboardLoading => 'Loading dashboard...';

  @override
  String get parkingValidationLotNameRequired => 'Lot name is required';

  @override
  String get parkingValidationAddressRequired => 'Address is required';

  @override
  String get parkingValidationLatitudeInvalid =>
      'Latitude must be between -90 and 90';

  @override
  String get parkingValidationLongitudeInvalid =>
      'Longitude must be between -180 and 180';

  @override
  String get parkingValidationTotalSpacesInvalid =>
      'Total spaces must be at least 1';

  @override
  String get parkingValidationHourlyRateInvalid =>
      'Hourly rate must be 0 or greater';

  @override
  String get parkingDashboardSummary => 'Summary';

  @override
  String get parkingDashboardOccupancy => 'Occupancy';

  @override
  String get parkingDashboardFinancial => 'Financial';

  @override
  String get parkingDashboardBookings => 'Bookings';

  @override
  String get parkingDashboardTotalParkings => 'Total Parkings';

  @override
  String get parkingDashboardActiveParkings => 'Active';

  @override
  String get parkingDashboardPendingParkings => 'Pending';

  @override
  String get parkingDashboardRejectedParkings => 'Rejected';

  @override
  String get parkingDashboardTotalSpaces => 'Total Spaces';

  @override
  String get parkingDashboardAvailableSpaces => 'Available';

  @override
  String get parkingDashboardOccupiedSpaces => 'Occupied';

  @override
  String get parkingDashboardOccupancyRate => 'Occupancy Rate';

  @override
  String get parkingDashboardTotalRevenue => 'Total Revenue';

  @override
  String get parkingDashboardSuccessfulPayments => 'Successful Payments';

  @override
  String get parkingDashboardAverageHourlyRate => 'Average Hourly Rate';

  @override
  String get parkingDashboardRevenueToday => 'Today';

  @override
  String get parkingDashboardRevenueThisWeek => 'This Week';

  @override
  String get parkingDashboardRevenueThisMonth => 'This Month';

  @override
  String get parkingDashboardTotalBookings => 'Total Bookings';

  @override
  String get parkingDashboardActiveBookings => 'Active Bookings';

  @override
  String get parkingDashboardCancelledBookings => 'Cancelled';

  @override
  String get parkingDashboardActiveBookingsNow => 'Active Now';
}
