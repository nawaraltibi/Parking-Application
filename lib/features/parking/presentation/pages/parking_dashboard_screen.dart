import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/parking_cubit.dart';
import '../../models/owner_dashboard_stats_response.dart';
import '../widgets/dashboard_card.dart';

/// Parking Dashboard Screen
/// Modern, data-driven dashboard with welcome header, KPI cards, and occupancy indicators
/// 
/// Safety Features:
/// - Strict state-based rendering (only renders when data is loaded)
/// - No unsafe null assertions
/// - Validated percent calculations
/// - Safe string operations
/// - Proper layout constraints (no unbounded errors)
class ParkingDashboardScreen extends StatelessWidget {
  const ParkingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe localization access
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ParkingCubit, ParkingState>(
        buildWhen: (previous, current) {
          return current is DashboardLoading ||
              current is DashboardLoaded ||
              current is DashboardFailure;
        },
        builder: (context, state) {
          // Loading State
          if (state is DashboardLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          // Error State
          if (state is DashboardFailure) {
            String errorMessage = state.error;
            if (state.statusCode == 403) {
              errorMessage = l10n.parkingErrorUnauthorized;
            }

            return ErrorStateWidget(
              message: errorMessage,
              onRetry: () {
                context.read<ParkingCubit>().loadDashboardStats();
              },
            );
          }

          // Loaded State - Only render content when data is fully loaded
          if (state is DashboardLoaded) {
            final data = state.dashboardData;
            
            // Validate data before rendering
            if (!_isValidDashboardData(data)) {
              return ErrorStateWidget(
                message: 'بيانات غير صحيحة',
                onRetry: () {
                  context.read<ParkingCubit>().loadDashboardStats();
                },
              );
            }

            return DashboardContent(data: data);
          }

          // Initial state - trigger load
          if (state is ParkingInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ParkingCubit>().loadDashboardStats();
            });
          }

          // Default fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Validate dashboard data integrity
  bool _isValidDashboardData(DashboardData data) {
    try {
      // Check all required fields exist
      if (data.summary.ownerName.isEmpty) return false;
      if (data.occupancyStats.totalSpaces < 0) return false;
      if (data.occupancyStats.occupiedSpaces < 0) return false;
      if (data.occupancyStats.occupiedSpaces > data.occupancyStats.totalSpaces) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Dashboard Content Widget
/// Assumes data is fully loaded and validated
/// No null assertions - all data is guaranteed to be present
/// 
/// Layout Safety:
/// - Column uses mainAxisSize.min to prevent unbounded height
/// - All nested widgets have proper constraints
class DashboardContent extends StatelessWidget {
  final DashboardData data;

  const DashboardContent({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final cubit = context.read<ParkingCubit>();
        await cubit.loadDashboardStats();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Header
            _WelcomeHeader(ownerName: data.summary.ownerName),
            SizedBox(height: 24.h),

            // Primary KPI Card - Today's Revenue (Hero Section)
            _HeroKPICard(
              todayRevenue: data.financialStats.revenueByPeriod.today,
            ),
            SizedBox(height: 24.h),

            // Live Occupancy Indicator
            _OccupancyIndicator(stats: data.occupancyStats),
            SizedBox(height: 24.h),

            // Summary Stats Grid (2x2)
            _SummaryStatsGrid(data: data),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

/// Welcome Header Widget
/// Layout Safety: Column uses mainAxisSize.min
class _WelcomeHeader extends StatelessWidget {
  final String ownerName;

  const _WelcomeHeader({required this.ownerName});

  @override
  Widget build(BuildContext context) {
    // Safe owner name with fallback
    final displayName = ownerName.isNotEmpty ? ownerName : 'المستخدم';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحباً، $displayName 👋',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
            height: 1.2,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'نظرة عامة على أداء مواقفك',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

/// Primary KPI Card - Today's Revenue (Hero Section)
/// Layout Safety: Column uses mainAxisSize.min, Expanded properly constrained in Row
class _HeroKPICard extends StatelessWidget {
  final String todayRevenue;

  const _HeroKPICard({required this.todayRevenue});

  @override
  Widget build(BuildContext context) {
    // Safe revenue display with fallback
    final displayRevenue = todayRevenue.isNotEmpty ? todayRevenue : '0.00 ر.س';

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  AppIcons.currencySolid,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إيرادات اليوم',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      displayRevenue,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Live Occupancy Indicator with CircularPercentIndicator
/// Layout Safety: Column uses mainAxisSize.min, nested Column in center also uses mainAxisSize.min
class _OccupancyIndicator extends StatelessWidget {
  final OccupancyStats stats;

  const _OccupancyIndicator({required this.stats});

  @override
  Widget build(BuildContext context) {
    // Safe percent calculation with validation
    final totalSpaces = stats.totalSpaces > 0 ? stats.totalSpaces : 1;
    final occupiedSpaces = stats.occupiedSpaces.clamp(0, totalSpaces);
    
    // Calculate percent safely
    final occupancyPercent = (occupiedSpaces / totalSpaces).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'معدل الإشغال الحالي',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Percent Indicator - Safe with clamped values
              CircularPercentIndicator(
                radius: 80.r,
                lineWidth: 12.w,
                percent: occupancyPercent,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$occupiedSpaces',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '/ $totalSpaces',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                progressColor: AppColors.primary,
                backgroundColor: AppColors.backgroundSecondary,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1000,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '$occupiedSpaces / $totalSpaces مشغول',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Summary Stats Grid (2x2)
/// Layout Safety: Column uses mainAxisSize.min, Rows properly constrained with Expanded
class _SummaryStatsGrid extends StatelessWidget {
  final DashboardData data;

  const _SummaryStatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    // Safe value extraction with fallbacks
    final totalRevenue = data.financialStats.formattedTotalRevenue.isNotEmpty
        ? data.financialStats.formattedTotalRevenue
        : '0.00 ر.س';
    
    final totalBookings = data.bookingStats.totalBookings;
    final activeParkings = data.summary.activeParkings;
    final pendingCount = data.summary.pendingParkings + data.summary.rejectedParkings;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإحصائيات',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: 'إجمالي الإيرادات',
                value: totalRevenue,
                icon: AppIcons.revenue,
                color: AppColors.success,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardCard(
                title: 'إجمالي الحجوزات',
                value: '$totalBookings',
                icon: AppIcons.booking,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: DashboardCard(
                title: 'المواقف النشطة',
                value: '$activeParkings',
                icon: AppIcons.check,
                color: AppColors.success,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DashboardCard(
                title: 'قيد المراجعة',
                value: '$pendingCount',
                icon: AppIcons.warning,
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
