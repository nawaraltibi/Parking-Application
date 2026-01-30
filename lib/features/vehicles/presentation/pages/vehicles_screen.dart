import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/vehicles_list_refresh_notifier.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../bloc/vehicles_bloc.dart';
import '../utils/vehicles_error_handler.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicles_empty_state.dart';
import '../widgets/vehicles_error_state.dart';

/// Vehicles Screen (User side)
/// Displays list of user's vehicles using VehiclesBloc.
class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  List<VehicleEntity>? _cachedVehicles;
  bool _cachedEmpty = false;

  @override
  void initState() {
    super.initState();
    getIt<VehiclesListRefreshNotifier>().addListener(_onRefreshRequested);
  }

  void _onRefreshRequested() {
    if (!mounted) return;
    context.read<VehiclesBloc>().add(GetVehiclesRequested());
  }

  @override
  void dispose() {
    getIt<VehiclesListRefreshNotifier>().removeListener(_onRefreshRequested);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.vehiclesMyVehiclesTitle,
          style: AppTextStyles.titleLarge(context),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: AppColors.buttonGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.push(Routes.userMainVehiclesAddPath),
            borderRadius: BorderRadius.circular(28.0),
            child: Center(
              child: Icon(
                EvaIcons.plusCircle,
                color: AppColors.textOnPrimary,
                size: 28.0,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: BlocBuilder<VehiclesBloc, VehiclesState>(
          builder: (context, state) {
            Widget child;

            if (state is VehiclesLoaded) {
              _cachedVehicles = state.vehicles;
              _cachedEmpty = state.vehicles.isEmpty;
              child = _VehiclesList(
                vehicles: state.vehicles,
                onRefresh: () async {
                  context.read<VehiclesBloc>().add(GetVehiclesRequested());
                },
              );
            } else if (state is VehiclesEmpty) {
              _cachedVehicles = const [];
              _cachedEmpty = true;
              child = VehiclesEmptyState(
                onAddTap: () => context.push(Routes.userMainVehiclesAddPath),
              );
            } else if (state is VehiclesError) {
              final errorMessage = VehiclesErrorHandler.handleErrorState(
                state.error,
                state.statusCode,
                l10n,
              );
              child = VehiclesErrorState(
                error: errorMessage,
                onRetry: () =>
                    context.read<VehiclesBloc>().add(GetVehiclesRequested()),
              );
            } else if (state is VehiclesLoading) {
              child = const _VehiclesSkeleton();
            } else if (state is VehicleActionLoading ||
                state is VehicleActionSuccess ||
                state is VehicleActionFailure) {
              // Keep showing cached list/empty while actions are running.
              if (_cachedVehicles != null && _cachedVehicles!.isNotEmpty) {
                child = _VehiclesList(
                  vehicles: _cachedVehicles!,
                  onRefresh: () async {
                    context.read<VehiclesBloc>().add(GetVehiclesRequested());
                  },
                );
              } else if (_cachedEmpty) {
                child = VehiclesEmptyState(
                  onAddTap: () => context.push(Routes.userMainVehiclesAddPath),
                );
              } else {
                child = const _VehiclesSkeleton();
              }
            } else {
              // VehiclesInitial or any future states
              child = const _VehiclesSkeleton();
            }

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

class _VehiclesList extends StatelessWidget {
  final List<VehicleEntity> vehicles;
  final Future<void> Function() onRefresh;

  const _VehiclesList({required this.vehicles, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: 16.w,
          end: 16.w,
          bottom: 60.h,
          top: 12.h,
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: VehicleCard(
              key: ValueKey(vehicle.vehicleId),
              vehicle: vehicle,
            ),
          );
        },
      ),
    );
  }
}

class _VehiclesSkeleton extends StatelessWidget {
  const _VehiclesSkeleton();

  @override
  Widget build(BuildContext context) {
    // Keep it lightweight: use standard loader + subtle placeholder list.
    return Column(
      children: [
        const SizedBox(height: 24),
        const Center(child: LoadingWidget()),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _VehicleCardSkeleton(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VehicleCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonLine(widthFactor: 0.65),
              SizedBox(height: 12.h),
              _SkeletonLine(widthFactor: 0.9),
              SizedBox(height: 8.h),
              _SkeletonLine(widthFactor: 0.55),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;

  const _SkeletonLine({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
