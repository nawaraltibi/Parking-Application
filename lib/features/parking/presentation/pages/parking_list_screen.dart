import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/parking_cubit.dart';
import '../../core/enums/parking_filter.dart';
import '../../models/parking_model.dart';
import '../utils/parking_error_handler.dart';
import '../utils/parking_filter_service.dart';
import '../../bloc/parking_empty_state.dart';
import '../widgets/parking_filter_chips.dart';
import '../../bloc/parking_no_results_state.dart';
import '../widgets/parking_search_bar.dart';
import '../widgets/parking_status_badge.dart';

/// Parking List Screen
/// Modern parking list with search, filters, and interactive cards
class ParkingListScreen extends StatefulWidget {
  const ParkingListScreen({super.key});

  @override
  State<ParkingListScreen> createState() => _ParkingListScreenState();
}

class _ParkingListScreenState extends State<ParkingListScreen> {
  ParkingFilter _selectedFilter = ParkingFilter.all;
  String _searchQuery = '';
  List<ParkingModel>? _cachedFilteredParkings;
  String? _lastSearchQuery;
  ParkingFilter? _lastFilter;
  List<ParkingModel>? _lastParkings;

  List<ParkingModel> _getFilteredParkings(
    List<ParkingModel> parkings,
    String searchQuery,
    ParkingFilter filter,
  ) {
    // Return cached if inputs haven't changed
    if (_cachedFilteredParkings != null &&
        _lastSearchQuery == searchQuery &&
        _lastFilter == filter &&
        _lastParkings == parkings) {
      return _cachedFilteredParkings!;
    }

    final filtered = ParkingFilterService.filterParkings(
      parkings: parkings,
      searchQuery: searchQuery,
      filter: filter,
    );

    _cachedFilteredParkings = filtered;
    _lastSearchQuery = searchQuery;
    _lastFilter = filter;
    _lastParkings = parkings;

    return filtered;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _cachedFilteredParkings = null; // Invalidate cache
    });
  }

  void _onFilterChanged(ParkingFilter filter) {
    setState(() {
      _selectedFilter = filter;
      _cachedFilteredParkings = null; // Invalidate cache
    });
  }

  @override
  Widget build(BuildContext context) {
    // Safe localization access
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: BlocConsumer<ParkingCubit, ParkingState>(
        listener: (context, state) {
          // Handle success states
          if (state is ParkingCreateSuccess) {
            // Parking is already added optimistically in create_parking_screen
            // The cubit's createParking() already calls loadParkings() to sync with server
            // No additional action needed here - UI updates automatically via BlocBuilder
          } else if (state is ParkingUpdateSuccess) {
            UnifiedSnackbar.success(
              context,
              message: l10n.parkingSuccessUpdate,
            );
            // Update parking in list optimistically for instant UI feedback
            context.read<ParkingCubit>().updateParkingInList(state.parkingLot);
            // The cubit already calls loadParkings() to sync with server
          }
        },
        builder: (context, state) {
          if (state is ParkingLoading) {
            return const Center(child: LoadingWidget());
          }

          if (state is ParkingFailure) {
            final errorMessage = ParkingErrorHandler.handleErrorState(
              state.error,
              state.statusCode,
              l10n,
            );
            return ErrorStateWidget(
              message: errorMessage,
              onRetry: () {
                context.read<ParkingCubit>().loadParkings();
              },
            );
          }

          if (state is ParkingLoaded) {
            final parkings = state.parkings;

            if (parkings.isEmpty) {
              return ParkingEmptyState(
                onCreateTap: () => context.push('/create-parking'),
              );
            }

            final filteredParkings = _getFilteredParkings(
              parkings,
              _searchQuery,
              _selectedFilter,
            );

            return Column(
              children: [
                // Search Bar
                ParkingSearchBar(onChanged: _onSearchChanged),
                SizedBox(height: 12.h),

                // Filter Chips
                ParkingFilterChips(
                  selectedFilter: _selectedFilter,
                  onFilterChanged: _onFilterChanged,
                ),
                SizedBox(height: 12.h),

                // Parking List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<ParkingCubit>().loadParkings();
                    },
                    child: filteredParkings.isEmpty
                        ? const ParkingNoResultsState()
                        : ListView.builder(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 16.w,
                              bottom: 180
                                  .h, // Space for FAB (95.h) + bottom nav (58) + extra padding (27.h)
                            ),
                            itemCount: filteredParkings.length,
                            itemBuilder: (context, index) {
                              final parking = filteredParkings[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: ModernParkingCard(
                                  key: ValueKey(parking.lotId),
                                  parking: parking,
                                  onTap: () {
                                    context.push(
                                      '/update-parking',
                                      extra: parking,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          }

          // Initial state - load parkings
          if (state is ParkingInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ParkingCubit>().loadParkings();
            });
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 95.h,
        ), // Space above bottom nav bar (58 + 12 padding)
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: AppColors.buttonGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              context.push('/create-parking');
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(
              AppIcons.addSolid,
              color: AppColors.textOnPrimary,
              size: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}

/// Modern Parking Card Widget
/// Redesigned parking card with occupancy indicator and modern UI
///
/// Layout Safety:
/// - Column uses mainAxisSize.min to prevent unbounded height
/// - All Rows have proper constraints
/// - No nested scrollables
class ModernParkingCard extends StatelessWidget {
  final ParkingModel parking;
  final VoidCallback onTap;

  const ModernParkingCard({
    super.key,
    required this.parking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Calculate occupancy safely
    // TODO: Replace with actual occupied spaces from API when available
    // Currently using estimated occupancy (60% of total spaces)
    // The API endpoint /owner/parking/data doesn't provide occupied_spaces
    // Consider adding this field to ParkingModel when API is updated
    final totalSpaces = parking.totalSpaces > 0 ? parking.totalSpaces : 1;
    final occupiedSpaces = (totalSpaces * 0.6).round().clamp(0, totalSpaces);
    final occupancyPercent = (occupiedSpaces / totalSpaces).clamp(0.0, 1.0);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      parking.lotName,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ParkingStatusBadge(parking: parking),
                  SizedBox(width: 8.w),
                  PopupMenuButton(
                    icon: Icon(
                      AppIcons.more,
                      color: AppColors.secondaryText,
                      size: 20.sp,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(AppIcons.edit, size: 18.sp),
                            SizedBox(width: 8.w),
                            Text(l10n.parkingUpdateTitle),
                          ],
                        ),
                        onTap: () =>
                            Future.delayed(Duration.zero, () => onTap()),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Occupancy Indicator
              _buildOccupancyIndicator(occupancyPercent, occupiedSpaces, l10n),
              SizedBox(height: 16.h),

              // Footer with location and price
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: AppIcons.location,
                      text: parking.address,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInfoRow(
                      icon: AppIcons.currency,
                      text:
                          '${parking.hourlyRate.toStringAsFixed(2)} ${l10n.parkingStatusActive == 'Active' ? 'SAR/hour' : 'ر.س/ساعة'}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOccupancyIndicator(
    double percent,
    int occupied,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.parkingDashboardOccupancyRate,
              style: TextStyle(fontSize: 12.sp, color: AppColors.secondaryText),
            ),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearPercentIndicator(
          lineHeight: 8.h,
          percent: percent.clamp(0.0, 1.0),
          backgroundColor: AppColors.backgroundSecondary,
          progressColor: AppColors.primary,
          barRadius: Radius.circular(4.r),
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 4.h),
        Text(
          '$occupied / ${parking.totalSpaces} ${l10n.parkingDashboardOccupiedSpaces}',
          style: TextStyle(fontSize: 11.sp, color: AppColors.secondaryText),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.secondaryText),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13.sp, color: AppColors.secondaryText),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
