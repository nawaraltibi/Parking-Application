import 'package:get_it/get_it.dart';
import '../../features/auth/bloc/login/login_bloc.dart';
import '../../features/auth/bloc/register/register_bloc.dart';
import '../../features/auth/bloc/logout/logout_bloc.dart';
import '../../features/splash/bloc/splash_routing_bloc.dart';
import '../../features/profile/bloc/profile/profile_bloc.dart';
import '../../features/parking/cubit/parking_cubit.dart';
import '../../features/main_screen/bloc/owner_main/owner_main_bloc.dart';
import '../../features/main_screen/bloc/user_main/user_main_bloc.dart';
import '../../core/bloc/locale_cubit.dart';
import '../../features/vehicles/data/datasources/vehicles_remote_data_source.dart';
import '../../features/vehicles/data/repositories/vehicles_repository_impl.dart';
import '../../features/vehicles/domain/repositories/vehicles_repository.dart';
import '../../features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import '../../features/vehicles/domain/usecases/add_vehicle_usecase.dart';
import '../../features/vehicles/domain/usecases/update_vehicle_usecase.dart';
import '../../features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import '../../features/vehicles/presentation/bloc/vehicles_bloc.dart';
import '../../features/file_downloader/bloc/file_download_bloc.dart';
import '../../features/image_downloader/bloc/image_download_bloc.dart';
import '../../features/parking_map/data/datasources/parking_map_remote_datasource.dart';
import '../../features/parking_map/data/repositories/parking_map_repository_impl.dart';
import '../../features/parking_map/domain/repositories/parking_map_repository.dart';
import '../../features/parking_map/domain/usecases/get_all_parking_lots_usecase.dart';
import '../../features/parking_map/domain/usecases/get_parking_details_usecase.dart';
import '../../features/parking_map/presentation/bloc/parking_map_bloc.dart';
import '../../core/location/location_repository.dart';
import '../../core/location/location_service.dart';
import '../../core/location/get_current_location_usecase.dart';

/// Service Locator
/// Centralized Dependency Injection using GetIt
/// 
/// This is the single source of truth for all dependencies in the app.
/// All features should get their dependencies from here, not create them directly.
final getIt = GetIt.instance;

/// Initialize all dependencies
/// Must be called before running the app
Future<void> setupServiceLocator() async {
  // Core Services
  // DioProvider is already a singleton, but we register it for consistency
  // Note: DioProvider.instance is used directly in APIRequest, so we keep that pattern
  // We register it here for potential future use or testing
  
  // Data Sources
  getIt.registerLazySingleton<VehiclesRemoteDataSource>(
    () => VehiclesRemoteDataSource(),
  );

  getIt.registerLazySingleton<ParkingMapRemoteDataSource>(
    () => ParkingMapRemoteDataSource(),
  );

  // Location Service
  getIt.registerLazySingleton<LocationRepository>(
    () => LocationService(),
  );

  // Repositories
  getIt.registerLazySingleton<VehiclesRepository>(
    () => VehiclesRepositoryImpl(
      remoteDataSource: getIt<VehiclesRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<ParkingMapRepository>(
    () => ParkingMapRepositoryImpl(
      remoteDataSource: getIt<ParkingMapRemoteDataSource>(),
    ),
  );

  // Use Cases (Vehicles feature)
  getIt.registerLazySingleton<GetVehiclesUseCase>(
    () => GetVehiclesUseCase(getIt<VehiclesRepository>()),
  );

  getIt.registerLazySingleton<AddVehicleUseCase>(
    () => AddVehicleUseCase(getIt<VehiclesRepository>()),
  );

  getIt.registerLazySingleton<UpdateVehicleUseCase>(
    () => UpdateVehicleUseCase(getIt<VehiclesRepository>()),
  );

  getIt.registerLazySingleton<DeleteVehicleUseCase>(
    () => DeleteVehicleUseCase(getIt<VehiclesRepository>()),
  );

  // Use Cases (Parking Map feature)
  getIt.registerLazySingleton<GetAllParkingLotsUseCase>(
    () => GetAllParkingLotsUseCase(getIt<ParkingMapRepository>()),
  );

  getIt.registerLazySingleton<GetParkingDetailsUseCase>(
    () => GetParkingDetailsUseCase(getIt<ParkingMapRepository>()),
  );

  // Use Cases (Location)
  getIt.registerLazySingleton<GetCurrentLocationUseCase>(
    () => GetCurrentLocationUseCase(getIt<LocationRepository>()),
  );

  // BLoCs / Cubits
  // These are registered as factories because each screen needs its own instance
  // However, some blocs are app-wide (like LocaleCubit, SplashRoutingBloc)
  // and should be singletons
  
  // App-wide blocs (singletons)
  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(),
  );

  getIt.registerLazySingleton<SplashRoutingBloc>(
    () => SplashRoutingBloc(),
  );

  // Feature blocs (factories - new instance per screen)
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(),
  );

  getIt.registerFactory<LogoutBloc>(
    () => LogoutBloc(),
  );

  getIt.registerFactory<ProfileBloc>(
    () => ProfileBloc(),
  );

  getIt.registerFactory<ParkingCubit>(
    () => ParkingCubit(),
  );

  getIt.registerFactory<OwnerMainBloc>(
    () => OwnerMainBloc(),
  );

  getIt.registerFactory<UserMainBloc>(
    () => UserMainBloc(),
  );

  getIt.registerFactory<VehiclesBloc>(
    () => VehiclesBloc(
      getVehiclesUseCase: getIt<GetVehiclesUseCase>(),
      addVehicleUseCase: getIt<AddVehicleUseCase>(),
      updateVehicleUseCase: getIt<UpdateVehicleUseCase>(),
      deleteVehicleUseCase: getIt<DeleteVehicleUseCase>(),
    ),
  );

  getIt.registerFactory<FileDownloadBloc>(
    () => FileDownloadBloc(),
  );

  getIt.registerFactory<ImageDownloadBloc>(
    () => ImageDownloadBloc(),
  );

  getIt.registerFactory<ParkingMapBloc>(
    () => ParkingMapBloc(
      getAllParkingLotsUseCase: getIt<GetAllParkingLotsUseCase>(),
      getParkingDetailsUseCase: getIt<GetParkingDetailsUseCase>(),
      getCurrentLocationUseCase: getIt<GetCurrentLocationUseCase>(),
    ),
  );
}

/// Reset service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await getIt.reset();
}

