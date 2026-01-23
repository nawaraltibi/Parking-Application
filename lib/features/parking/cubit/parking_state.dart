part of 'parking_cubit.dart';

/// Parking State
/// 
/// Single, comprehensive state that holds all parking-related data.
/// 
/// Design Principles:
/// 1. Single source of truth: parkings list is always present
/// 2. Clear loading states: Separate flags for different operations
/// 3. Error handling: Errors don't clear the data
/// 4. Immutable: All updates create new instances
class ParkingState extends Equatable {
  /// List of parking lots (always present, may be empty)
  final List<ParkingModel> parkings;

  /// Loading state for parking list
  final bool isLoading;

  /// Creating state for new parking
  final bool isCreating;

  /// Updating state for existing parking
  final bool isUpdating;

  /// Error message (if any)
  final String? error;

  /// Error status code (if any)
  final int? statusCode;

  /// Dashboard data
  final DashboardData? dashboardData;

  /// Loading state for dashboard
  final bool isLoadingDashboard;

  /// Dashboard error message (if any)
  final String? dashboardError;

  /// Dashboard error status code (if any)
  final int? dashboardStatusCode;

  const ParkingState({
    required this.parkings,
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.error,
    this.statusCode,
    this.dashboardData,
    this.isLoadingDashboard = false,
    this.dashboardError,
    this.dashboardStatusCode,
  });

  /// Initial state with empty list
  const ParkingState.initial()
      : parkings = const [],
        isLoading = false,
        isCreating = false,
        isUpdating = false,
        error = null,
        statusCode = null,
        dashboardData = null,
        isLoadingDashboard = false,
        dashboardError = null,
        dashboardStatusCode = null;

  /// Create a copy with updated fields
  ParkingState copyWith({
    List<ParkingModel>? parkings,
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    String? error,
    int? statusCode,
    DashboardData? dashboardData,
    bool? isLoadingDashboard,
    String? dashboardError,
    int? dashboardStatusCode,
  }) {
    return ParkingState(
      parkings: parkings ?? this.parkings,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      error: error,
      statusCode: statusCode ?? this.statusCode,
      dashboardData: dashboardData ?? this.dashboardData,
      isLoadingDashboard: isLoadingDashboard ?? this.isLoadingDashboard,
      dashboardError: dashboardError,
      dashboardStatusCode: dashboardStatusCode ?? this.dashboardStatusCode,
    );
  }

  @override
  List<Object?> get props => [
        parkings,
        isLoading,
        isCreating,
        isUpdating,
        error,
        statusCode,
        dashboardData,
        isLoadingDashboard,
        dashboardError,
        dashboardStatusCode,
      ];
}

