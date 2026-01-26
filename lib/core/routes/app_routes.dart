/// App Routes
/// Centralized route path definitions
class Routes {
  // Auth routes
  static const String loginPath = '/login';
  static const String registerPath = '/register';

  // Main routes
  static const String homePath = '/home';
  static const String mainScreenPath = '/main';
  static const String ownerMainPath = '/owner-main';
  static const String userMainPath = '/user-main';
  static const String splashPath = '/splash';
  static const String welcomePath = '/welcome';
  static const String onboardingPath = '/onboarding';

  // Parking feature routes
  static const String parkingPath = '/parking';
  static const String parkingCreatePath = '/create-parking';
  static const String parkingUpdatePath = '/update-parking';
  static const String bookingPath = '/booking';
  static const String bookingPrePaymentPath = '/booking/pre-payment';
  static const String bookingDetailsPath = '/booking/details';
  static const String extendBookingPath = '/booking/extend';
  static const String paymentPath = '/payment';

  // Feature routes
  static const String profilePath = '/profile';
  static const String notificationsPath = '/notifications';

  // Vehicles feature routes
  static const String vehiclesPath = '/vehicles';
  static const String vehiclesAddPath = '/vehicles/add';
  static const String vehiclesEditPath = '/vehicles/edit';

  // Route names for pushNamed
  static const String notifications = 'notifications';
}

