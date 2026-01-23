import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/vehicles_bloc.dart';
import 'add_vehicle_screen.dart';

/// Add Vehicle Page
/// Reuses an existing VehiclesBloc if available; otherwise creates a new one.
class AddVehiclePage extends StatelessWidget {
  const AddVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      final existingBloc = context.read<VehiclesBloc>();
      return BlocProvider.value(
        value: existingBloc,
        child: const AddVehicleScreen(),
      );
    } catch (_) {
      return BlocProvider(
        create: (_) => getIt<VehiclesBloc>(),
        child: const AddVehicleScreen(),
      );
    }
  }
}


