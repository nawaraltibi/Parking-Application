import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Parking Application'**
  String get appTitle;

  /// First onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Discover nearby parking easily'**
  String get onboardingTitle1;

  /// First onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Find available parking spots near you with real-time availability and convenient locations.'**
  String get onboardingDescription1;

  /// Second onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Reserve your parking spot in seconds'**
  String get onboardingTitle2;

  /// Second onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Book your parking space instantly and secure your spot before you arrive. No more circling around!'**
  String get onboardingDescription2;

  /// Third onboarding screen title
  ///
  /// In en, this message translates to:
  /// **'Manage and monetize your parking'**
  String get onboardingTitle3;

  /// Third onboarding screen description
  ///
  /// In en, this message translates to:
  /// **'Parking owners can easily manage spaces, set pricing, and earn income from unused parking spots.'**
  String get onboardingDescription3;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Get started button text on last onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Login screen title
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authLoginTitle;

  /// Login screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue using the parking app'**
  String get authLoginSubtitle;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authLoginButton;

  /// Register screen title
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authRegisterTitle;

  /// Register screen subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to start using the parking app'**
  String get authRegisterSubtitle;

  /// Register button text
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegisterButton;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// Email field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// Password field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// Password field hint text in register screen
  ///
  /// In en, this message translates to:
  /// **'Enter your password (min 8 characters)'**
  String get authPasswordRegisterHint;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullNameLabel;

  /// Full name field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get authFullNameHint;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get authPhoneLabel;

  /// Phone field hint text
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get authPhoneHint;

  /// User type field label
  ///
  /// In en, this message translates to:
  /// **'User Type'**
  String get authUserTypeLabel;

  /// Regular user type option
  ///
  /// In en, this message translates to:
  /// **'Regular User'**
  String get authUserTypeRegular;

  /// Parking owner type option
  ///
  /// In en, this message translates to:
  /// **'Parking Owner'**
  String get authUserTypeOwner;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPasswordLabel;

  /// Confirm password field hint text
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authConfirmPasswordHint;

  /// Text before register link on login screen
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccount;

  /// Text before login link on register screen
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// Validation error for empty email
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get authValidationEmailRequired;

  /// Validation error for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get authValidationEmailInvalid;

  /// Validation error for empty password
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get authValidationPasswordRequired;

  /// Validation error for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get authValidationPasswordShort;

  /// Validation error for empty full name
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get authValidationFullNameRequired;

  /// Validation error for long full name
  ///
  /// In en, this message translates to:
  /// **'Full name must not exceed 255 characters'**
  String get authValidationFullNameLong;

  /// Validation error for empty phone
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get authValidationPhoneRequired;

  /// Validation error for empty user type
  ///
  /// In en, this message translates to:
  /// **'User type is required'**
  String get authValidationUserTypeRequired;

  /// Validation error for invalid user type
  ///
  /// In en, this message translates to:
  /// **'User type must be either \"user\" or \"owner\"'**
  String get authValidationUserTypeInvalid;

  /// Validation error for empty password confirmation
  ///
  /// In en, this message translates to:
  /// **'Password confirmation is required'**
  String get authValidationPasswordConfirmationRequired;

  /// Validation error for password mismatch
  ///
  /// In en, this message translates to:
  /// **'Password confirmation does not match'**
  String get authValidationPasswordMismatch;

  /// Error message for invalid login credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid Email or Password'**
  String get authErrorInvalidCredentials;

  /// Generic error message for unexpected errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get authErrorUnexpected;

  /// Error message for unauthenticated users
  ///
  /// In en, this message translates to:
  /// **'Unauthenticated.'**
  String get authErrorUnauthenticated;

  /// Message for owner account pending approval
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval'**
  String get authErrorAccountPending;

  /// Message for owner account pending approval after login
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval. Please wait until your account is activated.'**
  String get authErrorOwnerPendingApproval;

  /// Message for blocked user account
  ///
  /// In en, this message translates to:
  /// **'Your account has been blocked. Please contact support'**
  String get authErrorAccountBlocked;

  /// Success message for owner registration pending approval
  ///
  /// In en, this message translates to:
  /// **'Your account is pending admin approval. You will be notified once approved.'**
  String get authSuccessRegisterPending;

  /// Success message after logout
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get authSuccessLogout;

  /// Profile screen title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get authProfileTitle;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogoutButton;

  /// Logout confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogoutDialogTitle;

  /// Logout confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get authLogoutDialogMessage;

  /// Cancel button in logout dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get authLogoutDialogCancel;

  /// Confirm button in logout dialog
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get authLogoutDialogConfirm;

  /// Owner tab label for parking management
  ///
  /// In en, this message translates to:
  /// **'Parking Management'**
  String get ownerTabParkingManagement;

  /// Owner tab label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get ownerTabProfile;

  /// User tab label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get userTabHome;

  /// User tab label for vehicles
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get userTabVehicles;

  /// User tab label for parking bookings
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get userTabParkings;

  /// User tab label for profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get userTabProfile;

  /// Placeholder text for pages under development
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get placeholderComingSoon;

  /// Button to edit profile
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditButton;

  /// Button to save profile changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profileSaveButton;

  /// Button to cancel profile editing
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profileCancelButton;

  /// Button to update password
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get profileUpdatePasswordButton;

  /// Button to delete account
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccountButton;

  /// Label for number of vehicles
  ///
  /// In en, this message translates to:
  /// **'Number of Vehicles'**
  String get profileNumberOfVehicles;

  /// Label for current password field
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get profileCurrentPasswordLabel;

  /// Hint for current password field
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get profileCurrentPasswordHint;

  /// Label for new password field
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get profileNewPasswordLabel;

  /// Hint for new password field
  ///
  /// In en, this message translates to:
  /// **'Enter your new password (min 8 characters)'**
  String get profileNewPasswordHint;

  /// Label for confirm new password field
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get profileConfirmNewPasswordLabel;

  /// Hint for confirm new password field
  ///
  /// In en, this message translates to:
  /// **'Re-enter your new password'**
  String get profileConfirmNewPasswordHint;

  /// Label for password field in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get profileDeleteAccountPasswordLabel;

  /// Hint for password field in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Enter your password to confirm'**
  String get profileDeleteAccountPasswordHint;

  /// Title for update password dialog
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get profileUpdatePasswordDialogTitle;

  /// Title for delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profileDeleteAccountDialogTitle;

  /// Message for delete account confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get profileDeleteAccountDialogMessage;

  /// Confirm button in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get profileDeleteAccountDialogConfirm;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileSuccessUpdate;

  /// Success message after password update
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully. Please login again.'**
  String get profileSuccessPasswordUpdate;

  /// Success message after account deletion
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get profileSuccessDeleteAccount;

  /// Error message for incorrect password
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get profileErrorIncorrectPassword;

  /// Error message for password mismatch
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get profileErrorPasswordMismatch;

  /// Error message for duplicate email
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get profileErrorEmailExists;

  /// Loading message for profile
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get profileLoading;

  /// Retry button text for profile error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get profileRetryButton;

  /// Button to confirm and apply language change
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get profileChangeLanguageButton;

  /// Title for parking management screen
  ///
  /// In en, this message translates to:
  /// **'My Parkings'**
  String get parkingTitle;

  /// Title for create parking screen
  ///
  /// In en, this message translates to:
  /// **'Create Parking'**
  String get parkingCreateTitle;

  /// Title for update parking screen
  ///
  /// In en, this message translates to:
  /// **'Update Parking'**
  String get parkingUpdateTitle;

  /// Title for owner dashboard screen
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get parkingDashboardTitle;

  /// Label for parking lot name field
  ///
  /// In en, this message translates to:
  /// **'Lot Name'**
  String get parkingLotNameLabel;

  /// Hint for parking lot name field
  ///
  /// In en, this message translates to:
  /// **'Enter parking lot name'**
  String get parkingLotNameHint;

  /// Label for parking address field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get parkingAddressLabel;

  /// Hint for parking address field
  ///
  /// In en, this message translates to:
  /// **'Enter parking address'**
  String get parkingAddressHint;

  /// Label for latitude field
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get parkingLatitudeLabel;

  /// Hint for latitude field
  ///
  /// In en, this message translates to:
  /// **'Enter latitude (-90 to 90)'**
  String get parkingLatitudeHint;

  /// Label for longitude field
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get parkingLongitudeLabel;

  /// Hint for longitude field
  ///
  /// In en, this message translates to:
  /// **'Enter longitude (-180 to 180)'**
  String get parkingLongitudeHint;

  /// Label for parking location selection section
  ///
  /// In en, this message translates to:
  /// **'Select Parking Location'**
  String get parkingSelectLocationLabel;

  /// Button text to open map for location selection
  ///
  /// In en, this message translates to:
  /// **'Choose location on map'**
  String get parkingChooseLocationButton;

  /// Message shown when location is not selected
  ///
  /// In en, this message translates to:
  /// **'Location not selected'**
  String get parkingLocationNotSelected;

  /// Title for map picker screen
  ///
  /// In en, this message translates to:
  /// **'Select Parking Location'**
  String get parkingMapScreenTitle;

  /// Button text to confirm selected location on map
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get parkingConfirmLocationButton;

  /// Error message when location permission is denied
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to select your current location'**
  String get parkingLocationPermissionDenied;

  /// Error message when location cannot be retrieved
  ///
  /// In en, this message translates to:
  /// **'Unable to get your location. Please select a location on the map.'**
  String get parkingLocationError;

  /// Label for total spaces field
  ///
  /// In en, this message translates to:
  /// **'Total Spaces'**
  String get parkingTotalSpacesLabel;

  /// Hint for total spaces field
  ///
  /// In en, this message translates to:
  /// **'Enter total parking spaces'**
  String get parkingTotalSpacesHint;

  /// Label for hourly rate field
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get parkingHourlyRateLabel;

  /// Hint for hourly rate field
  ///
  /// In en, this message translates to:
  /// **'Enter hourly rate'**
  String get parkingHourlyRateHint;

  /// Button text for creating parking
  ///
  /// In en, this message translates to:
  /// **'Create Parking'**
  String get parkingCreateButton;

  /// Button text for updating parking
  ///
  /// In en, this message translates to:
  /// **'Update Parking'**
  String get parkingUpdateButton;

  /// Status badge text for pending parking
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get parkingStatusPending;

  /// Status badge text for approved parking
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get parkingStatusApproved;

  /// Status badge text for rejected parking
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get parkingStatusRejected;

  /// Status badge text for active parking
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get parkingStatusActive;

  /// Status badge text for inactive parking
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get parkingStatusInactive;

  /// Empty state message when no parkings exist
  ///
  /// In en, this message translates to:
  /// **'No parking lots yet'**
  String get parkingEmptyState;

  /// Empty state subtitle
  ///
  /// In en, this message translates to:
  /// **'Create your first parking lot to get started'**
  String get parkingEmptyStateSubtitle;

  /// Message shown when updating parking
  ///
  /// In en, this message translates to:
  /// **'Updating this parking will require admin approval again'**
  String get parkingUpdateRequiresApproval;

  /// Title for update confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Update'**
  String get parkingUpdateConfirmTitle;

  /// Message for update confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This update will be sent to admin for approval. Continue?'**
  String get parkingUpdateConfirmMessage;

  /// Success message after creating parking
  ///
  /// In en, this message translates to:
  /// **'Parking created successfully. Waiting for admin approval.'**
  String get parkingSuccessCreate;

  /// Success message after updating parking
  ///
  /// In en, this message translates to:
  /// **'Parking update request submitted. Waiting for admin approval.'**
  String get parkingSuccessUpdate;

  /// Error message for unauthorized access
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action'**
  String get parkingErrorUnauthorized;

  /// Error message when parking not found
  ///
  /// In en, this message translates to:
  /// **'Parking lot not found'**
  String get parkingErrorNotFound;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get parkingRetryButton;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading parkings...'**
  String get parkingLoading;

  /// Creating message
  ///
  /// In en, this message translates to:
  /// **'Creating parking...'**
  String get parkingCreating;

  /// Updating message
  ///
  /// In en, this message translates to:
  /// **'Updating parking...'**
  String get parkingUpdating;

  /// Dashboard loading message
  ///
  /// In en, this message translates to:
  /// **'Loading dashboard...'**
  String get parkingDashboardLoading;

  /// Validation error for empty lot name
  ///
  /// In en, this message translates to:
  /// **'Lot name is required'**
  String get parkingValidationLotNameRequired;

  /// Validation error for empty address
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get parkingValidationAddressRequired;

  /// Validation error for invalid latitude
  ///
  /// In en, this message translates to:
  /// **'Latitude must be between -90 and 90'**
  String get parkingValidationLatitudeInvalid;

  /// Validation error for invalid longitude
  ///
  /// In en, this message translates to:
  /// **'Longitude must be between -180 and 180'**
  String get parkingValidationLongitudeInvalid;

  /// Validation error for invalid total spaces
  ///
  /// In en, this message translates to:
  /// **'Total spaces must be at least 1'**
  String get parkingValidationTotalSpacesInvalid;

  /// Validation error for invalid hourly rate
  ///
  /// In en, this message translates to:
  /// **'Hourly rate must be 0 or greater'**
  String get parkingValidationHourlyRateInvalid;

  /// Dashboard summary section title
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get parkingDashboardSummary;

  /// Dashboard occupancy section title
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get parkingDashboardOccupancy;

  /// Dashboard financial section title
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get parkingDashboardFinancial;

  /// Dashboard bookings section title
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get parkingDashboardBookings;

  /// Dashboard total parkings label
  ///
  /// In en, this message translates to:
  /// **'Total Parkings'**
  String get parkingDashboardTotalParkings;

  /// Dashboard active parkings label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get parkingDashboardActiveParkings;

  /// Dashboard pending parkings label
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get parkingDashboardPendingParkings;

  /// Dashboard rejected parkings label
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get parkingDashboardRejectedParkings;

  /// Dashboard total spaces label
  ///
  /// In en, this message translates to:
  /// **'Total Spaces'**
  String get parkingDashboardTotalSpaces;

  /// Dashboard available spaces label
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get parkingDashboardAvailableSpaces;

  /// Dashboard occupied spaces label
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get parkingDashboardOccupiedSpaces;

  /// Dashboard occupancy rate label
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get parkingDashboardOccupancyRate;

  /// Dashboard total revenue label
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get parkingDashboardTotalRevenue;

  /// Dashboard successful payments label
  ///
  /// In en, this message translates to:
  /// **'Successful Payments'**
  String get parkingDashboardSuccessfulPayments;

  /// Dashboard average hourly rate label
  ///
  /// In en, this message translates to:
  /// **'Average Hourly Rate'**
  String get parkingDashboardAverageHourlyRate;

  /// Dashboard revenue today label
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get parkingDashboardRevenueToday;

  /// Dashboard revenue this week label
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get parkingDashboardRevenueThisWeek;

  /// Dashboard revenue this month label
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get parkingDashboardRevenueThisMonth;

  /// Dashboard total bookings label
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get parkingDashboardTotalBookings;

  /// Dashboard active bookings label
  ///
  /// In en, this message translates to:
  /// **'Active Bookings'**
  String get parkingDashboardActiveBookings;

  /// Dashboard cancelled bookings label
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get parkingDashboardCancelledBookings;

  /// Dashboard active bookings now label
  ///
  /// In en, this message translates to:
  /// **'Active Now'**
  String get parkingDashboardActiveBookingsNow;

  /// Dashboard welcome message with owner name
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name} 👋'**
  String parkingDashboardWelcome(String name);

  /// Dashboard overview subtitle
  ///
  /// In en, this message translates to:
  /// **'Overview of your parking performance'**
  String get parkingDashboardOverview;

  /// Dashboard today's revenue label
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get parkingDashboardTodayRevenue;

  /// Dashboard current occupancy rate label
  ///
  /// In en, this message translates to:
  /// **'Current Occupancy Rate'**
  String get parkingDashboardCurrentOccupancyRate;

  /// Dashboard occupied spaces label
  ///
  /// In en, this message translates to:
  /// **'Occupied'**
  String get parkingDashboardOccupied;

  /// Dashboard statistics section title
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get parkingDashboardStatistics;

  /// Error message for invalid dashboard data
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get parkingDashboardErrorInvalidData;

  /// Fallback text when owner name is not available
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get parkingDashboardUserFallback;

  /// Dashboard under review label
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get parkingDashboardUnderReview;

  /// Default revenue value when no data available
  ///
  /// In en, this message translates to:
  /// **'0.00 SYP'**
  String get parkingDashboardDefaultRevenue;

  /// Currency symbol for Syrian Pound in English
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get currencySymbol;

  /// Title for my vehicles screen
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get vehiclesMyVehiclesTitle;

  /// Title for add vehicle screen
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get vehiclesAddTitle;

  /// Title for edit vehicle screen
  ///
  /// In en, this message translates to:
  /// **'Edit Vehicle'**
  String get vehiclesEditTitle;

  /// Label for car make field
  ///
  /// In en, this message translates to:
  /// **'Car Make'**
  String get vehiclesFormNameLabel;

  /// Hint for car make field
  ///
  /// In en, this message translates to:
  /// **'Select car make'**
  String get vehiclesFormNameHint;

  /// Label for plate number field
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get vehiclesFormPlateLabel;

  /// Hint for plate number field
  ///
  /// In en, this message translates to:
  /// **'Enter plate number'**
  String get vehiclesFormPlateHint;

  /// Label for car model field
  ///
  /// In en, this message translates to:
  /// **'Car Model'**
  String get vehiclesFormTypeLabel;

  /// Hint for car model field
  ///
  /// In en, this message translates to:
  /// **'Enter car model'**
  String get vehiclesFormTypeHint;

  /// Label for vehicle color field
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get vehiclesFormColorLabel;

  /// Hint for vehicle color field
  ///
  /// In en, this message translates to:
  /// **'Select color'**
  String get vehiclesFormColorHint;

  /// Other option for dropdowns
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get vehiclesFormOther;

  /// Hint for other car make input
  ///
  /// In en, this message translates to:
  /// **'Enter car make'**
  String get vehiclesFormOtherCarMake;

  /// Placeholder for dropdown fields
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get vehiclesFormPleaseSelect;

  /// Button text for add vehicle submit
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get vehiclesAddButton;

  /// Button text for save vehicle changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get vehiclesSaveButton;

  /// Title for vehicles empty state
  ///
  /// In en, this message translates to:
  /// **'No vehicles yet'**
  String get vehiclesEmptyTitle;

  /// Subtitle for vehicles empty state
  ///
  /// In en, this message translates to:
  /// **'Add your first vehicle to get started'**
  String get vehiclesEmptySubtitle;

  /// Vehicle status: active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get vehiclesStatusActive;

  /// Vehicle status: inactive/blocked
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get vehiclesStatusInactive;

  /// Vehicle status: pending modification request
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get vehiclesStatusPending;

  /// Vehicle status: rejected modification request
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get vehiclesStatusRejected;

  /// Title for delete vehicle confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Vehicle'**
  String get vehiclesDeleteDialogTitle;

  /// Message for delete vehicle confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle?'**
  String get vehiclesDeleteDialogMessage;

  /// Success message after adding vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle added successfully'**
  String get vehiclesSuccessAdded;

  /// Success message after requesting vehicle update
  ///
  /// In en, this message translates to:
  /// **'Update request submitted. Waiting for admin approval.'**
  String get vehiclesSuccessUpdateRequested;

  /// Success message after deleting vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle deleted successfully'**
  String get vehiclesSuccessDeleted;

  /// Label for edit action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get vehiclesActionEdit;

  /// Label for delete action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get vehiclesActionDelete;

  /// Retry button text for vehicles error state
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get vehiclesRetryButton;

  /// Message shown on edit vehicle screen about admin approval
  ///
  /// In en, this message translates to:
  /// **'Updating this vehicle requires admin approval'**
  String get vehiclesUpdateRequiresApproval;

  /// Error message for unauthenticated (401)
  ///
  /// In en, this message translates to:
  /// **'Unauthenticated.'**
  String get vehiclesErrorUnauthorized;

  /// Error message for forbidden (403)
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action'**
  String get vehiclesErrorForbidden;

  /// Error message for validation (422)
  ///
  /// In en, this message translates to:
  /// **'Please check your input'**
  String get vehiclesErrorValidation;

  /// Error message for server error (500)
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again.'**
  String get vehiclesErrorServer;

  /// Cancel button in color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get vehiclesColorPickerCancel;

  /// Confirm button in color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get vehiclesColorPickerConfirm;

  /// Validation error for plate number minimum length
  ///
  /// In en, this message translates to:
  /// **'Plate number must be at least 3 characters'**
  String get vehiclesPlateNumberMinLength;

  /// Validation error for invalid plate number format
  ///
  /// In en, this message translates to:
  /// **'Plate number contains invalid characters'**
  String get vehiclesPlateNumberInvalid;

  /// Button text for custom color picker option
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get vehiclesColorPickerCustom;

  /// Title for custom color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Pick Custom Color'**
  String get vehiclesColorPickerCustomTitle;

  /// Search placeholder in dropdown
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get vehiclesFormSearch;

  /// No data message in dropdown
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get vehiclesFormNoData;

  /// No description provided for @carMakeToyota.
  ///
  /// In en, this message translates to:
  /// **'Toyota'**
  String get carMakeToyota;

  /// No description provided for @carMakeHyundai.
  ///
  /// In en, this message translates to:
  /// **'Hyundai'**
  String get carMakeHyundai;

  /// No description provided for @carMakeNissan.
  ///
  /// In en, this message translates to:
  /// **'Nissan'**
  String get carMakeNissan;

  /// No description provided for @carMakeHonda.
  ///
  /// In en, this message translates to:
  /// **'Honda'**
  String get carMakeHonda;

  /// No description provided for @carMakeMitsubishi.
  ///
  /// In en, this message translates to:
  /// **'Mitsubishi'**
  String get carMakeMitsubishi;

  /// No description provided for @carMakeSuzuki.
  ///
  /// In en, this message translates to:
  /// **'Suzuki'**
  String get carMakeSuzuki;

  /// No description provided for @carMakeMazda.
  ///
  /// In en, this message translates to:
  /// **'Mazda'**
  String get carMakeMazda;

  /// No description provided for @carMakeMercedes.
  ///
  /// In en, this message translates to:
  /// **'Mercedes'**
  String get carMakeMercedes;

  /// No description provided for @carMakeBMW.
  ///
  /// In en, this message translates to:
  /// **'BMW'**
  String get carMakeBMW;

  /// No description provided for @carMakeAudi.
  ///
  /// In en, this message translates to:
  /// **'Audi'**
  String get carMakeAudi;

  /// No description provided for @carMakeVolkswagen.
  ///
  /// In en, this message translates to:
  /// **'Volkswagen'**
  String get carMakeVolkswagen;

  /// No description provided for @carMakeOpel.
  ///
  /// In en, this message translates to:
  /// **'Opel'**
  String get carMakeOpel;

  /// No description provided for @carMakePeugeot.
  ///
  /// In en, this message translates to:
  /// **'Peugeot'**
  String get carMakePeugeot;

  /// No description provided for @carMakeRenault.
  ///
  /// In en, this message translates to:
  /// **'Renault'**
  String get carMakeRenault;

  /// No description provided for @carMakeCitroen.
  ///
  /// In en, this message translates to:
  /// **'Citroën'**
  String get carMakeCitroen;

  /// No description provided for @carMakeKia.
  ///
  /// In en, this message translates to:
  /// **'Kia'**
  String get carMakeKia;

  /// No description provided for @carMakeLexus.
  ///
  /// In en, this message translates to:
  /// **'Lexus'**
  String get carMakeLexus;

  /// No description provided for @carMakeSubaru.
  ///
  /// In en, this message translates to:
  /// **'Subaru'**
  String get carMakeSubaru;

  /// No description provided for @carMakeFord.
  ///
  /// In en, this message translates to:
  /// **'Ford'**
  String get carMakeFord;

  /// No description provided for @carMakeChevrolet.
  ///
  /// In en, this message translates to:
  /// **'Chevrolet'**
  String get carMakeChevrolet;

  /// No description provided for @carMakeDodge.
  ///
  /// In en, this message translates to:
  /// **'Dodge'**
  String get carMakeDodge;

  /// No description provided for @carMakeJeep.
  ///
  /// In en, this message translates to:
  /// **'Jeep'**
  String get carMakeJeep;

  /// No description provided for @carMakeGMC.
  ///
  /// In en, this message translates to:
  /// **'GMC'**
  String get carMakeGMC;

  /// No description provided for @carMakeChery.
  ///
  /// In en, this message translates to:
  /// **'Chery'**
  String get carMakeChery;

  /// No description provided for @carMakeGeely.
  ///
  /// In en, this message translates to:
  /// **'Geely'**
  String get carMakeGeely;

  /// No description provided for @carMakeBYD.
  ///
  /// In en, this message translates to:
  /// **'BYD'**
  String get carMakeBYD;

  /// No description provided for @carMakeDacia.
  ///
  /// In en, this message translates to:
  /// **'Dacia'**
  String get carMakeDacia;

  /// No description provided for @carMakeSaipa.
  ///
  /// In en, this message translates to:
  /// **'Saipa'**
  String get carMakeSaipa;

  /// No description provided for @carMakeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get carMakeOther;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver'**
  String get colorSilver;

  /// No description provided for @colorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get colorGray;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// No description provided for @colorBeige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get colorBeige;

  /// No description provided for @colorGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get colorGold;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @colorOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get colorOrange;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get colorPurple;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorMaroon.
  ///
  /// In en, this message translates to:
  /// **'Maroon'**
  String get colorMaroon;

  /// No description provided for @colorNavy.
  ///
  /// In en, this message translates to:
  /// **'Navy'**
  String get colorNavy;

  /// No description provided for @colorBurgundy.
  ///
  /// In en, this message translates to:
  /// **'Burgundy'**
  String get colorBurgundy;

  /// No description provided for @colorTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get colorTeal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
