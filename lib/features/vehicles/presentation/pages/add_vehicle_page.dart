import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/vehicles_bloc.dart';
import 'add_vehicle_screen.dart';

/// Add Vehicle Page
/// Reuses an existing VehiclesBloc if available; otherwise creates a new one.
/// Accepts optional source parameter to determine navigation behavior after success.
class AddVehiclePage extends StatelessWidget {
  final String? source; // 'booking_pre_payment' or 'vehicles_list'
  final Map<String, dynamic>? returnData; // Data to pass back when navigating
  
  const AddVehiclePage({
    super.key,
    this.source,
    this.returnData,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final existingBloc = context.read<VehiclesBloc>();
      return BlocProvider.value(
        value: existingBloc,
        child: AddVehicleScreen(
          source: source,
          returnData: returnData,
        ),
      );
    } catch (_) {
      return BlocProvider(
        create: (_) => getIt<VehiclesBloc>(),
        child: AddVehicleScreen(
          source: source,
          returnData: returnData,
        ),
      );
    }
  }
}


