import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../injection/service_locator.dart';
import '../../features/splash/presentation/splash_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/profile/presentation/profile_page.dart';
import '../../features/main_screen/presentation/owner_main_page.dart';
import '../../features/main_screen/presentation/user_main_page.dart';
import '../../features/parking/presentation/pages/create_parking_screen.dart';
import '../../features/parking/presentation/pages/update_parking_screen.dart';
import '../../features/parking/bloc/create_parking/create_parking_bloc.dart';
import '../../features/parking/bloc/update_parking/update_parking_bloc.dart';
import '../../features/parking/models/parking_model.dart';
import '../../features/vehicles/presentation/pages/add_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/edit_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import '../../features/vehicles/domain/entities/vehicle_entity.dart';
import '../../features/booking/presentation/pages/booking_pre_payment_screen.dart';
import '../../features/booking/presentation/pages/payment_screen.dart';
import '../../features/booking/presentation/pages/booking_details_screen.dart';
import '../../features/booking/bloc/create_booking/create_booking_bloc.dart';
import '../../features/vehicles/data/models/vehicle_model.dart';
import '../../l10n/app_localizations.dart';
import 'app_routes.dart';

/// App Pages
/// Route configuration using GoRouter
class Pages {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

/// App Router Configuration
/// Defines all routes in the application
final appPages = GoRouter(
  navigatorKey: Pages.navigatorKey,
  initialLocation: Routes.splashPath,
  routes: [
    GoRoute(
      path: Routes.splashPath,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.onboardingPath,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: Routes.loginPath,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.registerPath,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: Routes.ownerMainPath,
      builder: (context, state) => const OwnerMainPage(),
    ),
    GoRoute(
      path: Routes.userMainPath,
      builder: (context, state) => const UserMainPage(),
    ),
    GoRoute(
      path: Routes.homePath,
      builder: (context, state) {
        // TODO: Replace with actual HomePage when implemented
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),
          body: const Center(
            child: Text('Home Page - To be implemented'),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.profilePath,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: Routes.vehiclesPath,
      builder: (context, state) => const VehiclesPage(),
    ),
    GoRoute(
      path: Routes.vehiclesAddPath,
      builder: (context, state) {
        final extra = state.extra;
        String? source;
        Map<String, dynamic>? returnData;
        if (extra is Map<String, dynamic>) {
          source = extra['source'] as String?;
          returnData = extra['returnData'] as Map<String, dynamic>?;
        }
        return AddVehiclePage(
          source: source,
          returnData: returnData,
        );
      },
    ),
    GoRoute(
      path: Routes.vehiclesEditPath,
      builder: (context, state) {
        final vehicle = state.extra as VehicleEntity;
        return EditVehiclePage(vehicle: vehicle);
      },
    ),
    GoRoute(
      path: Routes.parkingCreatePath,
      builder: (context, state) {
        debugPrint('✅ app_pages: Creating new CreateParkingBloc instance');
        return BlocProvider(
          create: (context) => getIt<CreateParkingBloc>(),
          child: const CreateParkingScreen(),
        );
      },
    ),
    GoRoute(
      path: Routes.parkingUpdatePath,
      builder: (context, state) {
        final parking = state.extra as ParkingModel;
        debugPrint('✅ app_pages: Creating new UpdateParkingBloc instance');
        return BlocProvider(
          create: (context) => getIt<UpdateParkingBloc>(),
          child: UpdateParkingScreen(parking: parking),
        );
      },
    ),
    GoRoute(
      path: Routes.bookingPrePaymentPath,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final parking = data['parking'] as ParkingModel;
        final vehicles = data['vehicles'] as List<VehicleModel>;
        return BlocProvider(
          create: (context) => CreateBookingBloc(),
          child: BookingPrePaymentScreen(
            parking: parking,
            vehicles: vehicles,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.paymentPath,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final parking = data['parking'] as ParkingModel;
        final vehicle = data['vehicle'] as VehicleModel;
        final hours = data['hours'] as int;
        final totalAmount = data['totalAmount'] as double;
        final bookingId = data['bookingId'] as int? ?? 0;
        final startTime = data['startTime'] as DateTime?;
        final endTime = data['endTime'] as DateTime?;
        
        // Validate booking_id is present
        if (bookingId == 0) {
          // This should not happen if flow is correct, but handle gracefully
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: Center(
              child: Text(
                l10n?.errorInvalidBookingId ?? 'Invalid booking. Please try again.',
              ),
            ),
          );
        }
        
        return PaymentScreen(
          parking: parking,
          vehicle: vehicle,
          hours: hours,
          totalAmount: totalAmount,
          bookingId: bookingId,
          startTime: startTime,
          endTime: endTime,
        );
      },
    ),
    GoRoute(
      path: Routes.bookingDetailsPath,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        final bookingId = data?['bookingId'] as int? ?? 0;
        return BookingDetailsScreen(bookingId: bookingId);
      },
    ),
  ],
);

