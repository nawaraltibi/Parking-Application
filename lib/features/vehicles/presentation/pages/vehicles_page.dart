import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/vehicles_bloc.dart';
import 'vehicles_screen.dart';

/// Vehicles Page
/// Provides VehiclesBloc and triggers initial load.
class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VehiclesBloc>(
      create: (_) => getIt<VehiclesBloc>()..add(GetVehiclesRequested()),
      child: const VehiclesScreen(),
    );
  }
}


