import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../bloc/vehicles_bloc.dart';
import 'edit_vehicle_screen.dart';

/// Edit Vehicle Page
/// Reuses an existing VehiclesBloc if available; otherwise creates a new one.
class EditVehiclePage extends StatelessWidget {
  final VehicleEntity vehicle;

  const EditVehiclePage({
    super.key,
    required this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final existingBloc = context.read<VehiclesBloc>();
      return BlocProvider.value(
        value: existingBloc,
        child: EditVehicleScreen(vehicle: vehicle),
      );
    } catch (_) {
      return BlocProvider(
        create: (_) => getIt<VehiclesBloc>(),
        child: EditVehicleScreen(vehicle: vehicle),
      );
    }
  }
}


