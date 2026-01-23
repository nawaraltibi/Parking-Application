import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/parking_map_bloc.dart';
import 'parking_map_screen.dart';

/// Parking Map Page
/// Provides ParkingMapBloc and triggers initial load
class ParkingMapPage extends StatelessWidget {
  const ParkingMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParkingMapBloc>(
      create: (_) {
        final bloc = getIt<ParkingMapBloc>();
        // Load user location and parking lots on page load
        bloc.add(LoadUserLocation());
        bloc.add(LoadParkingLots());
        return bloc;
      },
      child: const ParkingMapScreen(),
    );
  }
}

