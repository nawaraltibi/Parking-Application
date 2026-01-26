/// Example: How to integrate AppBlocObserver in main.dart
/// 
/// This file shows the proper way to set up the global Bloc observer
/// with analytics integration in your Flutter app.

/*

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/bloc/app_bloc_observer.dart';
import 'core/services/analytics_service.dart';

void main() {
  // Initialize analytics service
  // Use MockAnalyticsService for development
  // Replace with FirebaseAnalyticsService in production
  final analyticsService = MockAnalyticsService();

  // Set up global Bloc observer
  Bloc.observer = AppBlocObserver(
    analyticsService: analyticsService,
  );

  // Run the app
  runApp(MyApp(analyticsService: analyticsService));
}

class MyApp extends StatelessWidget {
  final AnalyticsService analyticsService;

  const MyApp({
    Key? key,
    required this.analyticsService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

/// Example: Using Parking Blocs in a screen
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/parking/bloc/create_parking/create_parking_bloc.dart';
import 'features/parking/bloc/parking_list/parking_list_bloc.dart';
import 'features/parking/bloc/update_parking/update_parking_bloc.dart';
import 'features/parking/bloc/parking_stats/parking_stats_bloc.dart';

class OwnerDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ParkingListBloc>(
          create: (context) => ParkingListBloc()
            ..add(const LoadOwnerParkings()),
        ),
        BlocProvider<ParkingStatsBloc>(
          create: (context) => ParkingStatsBloc()
            ..add(const LoadParkingStats()),
        ),
        BlocProvider<CreateParkingBloc>(
          create: (context) => CreateParkingBloc(),
        ),
        BlocProvider<UpdateParkingBloc>(
          create: (context) => UpdateParkingBloc(),
        ),
      ],
      child: OwnerDashboardContent(),
    );
  }
}

class OwnerDashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Column(
        children: [
          // Statistics Section
          BlocBuilder<ParkingStatsBloc, ParkingStatsState>(
            builder: (context, state) {
              if (state is ParkingStatsLoading) {
                return CircularProgressIndicator();
              } else if (state is ParkingStatsLoaded) {
                return StatsCard(
                  totalRevenue: state.totalRevenue,
                  totalBookings: state.totalBookings,
                  totalParkingLots: state.totalParkingLots,
                );
              } else if (state is ParkingStatsError) {
                return Text('Error: ${state.message}');
              }
              return SizedBox.shrink();
            },
          ),
          
          // Parking List Section
          Expanded(
            child: BlocBuilder<ParkingListBloc, ParkingListState>(
              builder: (context, state) {
                if (state is ParkingListLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ParkingListLoaded) {
                  return ListView.builder(
                    itemCount: state.count,
                    itemBuilder: (context, index) {
                      final parking = state.filteredParkings[index];
                      return ParkingListTile(parking: parking);
                    },
                  );
                } else if (state is ParkingListError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create parking screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<CreateParkingBloc>(),
                child: CreateParkingScreen(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

/// Example: Listening to Bloc events with observer
/// 
/// The AppBlocObserver will automatically log all these events:
/// 
/// 1. When you dispatch an event:
///    context.read<CreateParkingBloc>().add(UpdateLotName('My Parking'));
///    
///    Console output:
///    📤 EVENT
///    ┌─────────────────────────────────────────────────────────────
///    │ 🎯 Bloc: CreateParkingBloc
///    │ 📤 Event: UpdateLotName
///    │ 📝 Details: UpdateLotName('My Parking')
///    └─────────────────────────────────────────────────────────────
///    
///    Analytics sent:
///    📊 [Analytics] Event: bloc_event
///       Parameters: {
///         event_name: 'UpdateLotName',
///         bloc_type: 'CreateParkingBloc',
///         timestamp: '2026-01-24T10:30:00.000Z',
///         event_details: 'UpdateLotName('My Parking')'
///       }
/// 
/// 2. When state transitions:
///    Console output:
///    🔄 TRANSITION
///    ┌─────────────────────────────────────────────────────────────
///    │ 🎯 Bloc: CreateParkingBloc
///    │ 🔄 Transition:
///    │   Current:  CreateParkingInitial
///    │   Event:    UpdateLotName
///    │   Next:     CreateParkingInitial
///    └─────────────────────────────────────────────────────────────
/// 
/// 3. When errors occur:
///    Console output:
///    ❌ ERROR
///    ┌─────────────────────────────────────────────────────────────
///    │ 🎯 Bloc: CreateParkingBloc
///    │ ❌ Error: AppException
///    │ 📝 Message: Invalid parking data
///    │ 📍 Stack Trace:
///    [Stack trace details...]
///    └─────────────────────────────────────────────────────────────
///    
///    Analytics sent:
///    📊 [Analytics] Event: bloc_error
///       Parameters: {
///         bloc_type: 'CreateParkingBloc',
///         error_type: 'AppException',
///         error_message: 'Invalid parking data',
///         timestamp: '2026-01-24T10:30:00.000Z',
///         has_stack_trace: true
///       }

*/

