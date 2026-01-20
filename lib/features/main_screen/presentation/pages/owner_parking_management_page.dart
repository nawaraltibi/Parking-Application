import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../parking/bloc/parking_cubit.dart';
import '../../../parking/presentation/pages/parking_list_screen.dart';
import '../../../parking/presentation/pages/parking_dashboard_screen.dart';

/// Owner Parking Management Page
/// Main page for parking management with tabs for list and dashboard
class OwnerParkingManagementPage extends StatefulWidget {
  const OwnerParkingManagementPage({super.key});

  @override
  State<OwnerParkingManagementPage> createState() =>
      _OwnerParkingManagementPageState();
}

class _OwnerParkingManagementPageState
    extends State<OwnerParkingManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => ParkingCubit(),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: const Icon(AppIcons.myParkings),
                  text: l10n.parkingTitle,
                ),
                Tab(
                  icon: const Icon(AppIcons.dashboard),
                  text: l10n.parkingDashboardTitle,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ParkingListScreen(),
                  ParkingDashboardScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
