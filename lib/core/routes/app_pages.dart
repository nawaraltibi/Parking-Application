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
import '../../features/parking/cubit/parking_cubit.dart';
import '../../features/parking/models/parking_model.dart';
import '../../features/vehicles/presentation/pages/add_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/edit_vehicle_page.dart';
import '../../features/vehicles/presentation/pages/vehicles_page.dart';
import '../../features/vehicles/domain/entities/vehicle_entity.dart';
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
      builder: (context, state) => const AddVehiclePage(),
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
        // Try to get existing ParkingCubit from context (shared instance)
        // This ensures we use the same instance as the parking list screen
        try {
          final existingCubit = context.read<ParkingCubit>();
          debugPrint('✅ app_pages: Found existing ParkingCubit instance: ${existingCubit.hashCode}');
          return BlocProvider.value(
            value: existingCubit,
            child: const CreateParkingScreen(),
          );
        } catch (e) {
          // Fallback: create new instance if not found in context
          // This should rarely happen if navigation is from parking management screen
          debugPrint('⚠️ app_pages: Creating new ParkingCubit instance (not found in context): $e');
          return BlocProvider(
            create: (context) => getIt<ParkingCubit>(),
            child: const CreateParkingScreen(),
          );
        }
      },
    ),
    GoRoute(
      path: Routes.parkingUpdatePath,
      builder: (context, state) {
        final parking = state.extra as ParkingModel;
        // Try to get existing ParkingCubit from context (shared instance)
        try {
          final existingCubit = context.read<ParkingCubit>();
          return BlocProvider.value(
            value: existingCubit,
            child: UpdateParkingScreen(parking: parking),
          );
        } catch (e) {
          // Fallback: create new instance if not found in context
          return BlocProvider(
            create: (context) => getIt<ParkingCubit>(),
            child: UpdateParkingScreen(parking: parking),
          );
        }
      },
    ),
  ],
);

