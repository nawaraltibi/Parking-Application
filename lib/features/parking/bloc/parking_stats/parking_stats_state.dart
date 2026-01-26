part of 'parking_stats_bloc.dart';

/// Base class for parking stats states
abstract class ParkingStatsState extends Equatable {
  const ParkingStatsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ParkingStatsInitial extends ParkingStatsState {
  const ParkingStatsInitial();
}

/// Loading state
class ParkingStatsLoading extends ParkingStatsState {
  const ParkingStatsLoading();
}

/// Loaded state with statistics data
class ParkingStatsLoaded extends ParkingStatsState {
  final OwnerDashboardStatsResponse response;
  final DateRange? dateRange;

  const ParkingStatsLoaded({
    required this.response,
    this.dateRange,
  });

  @override
  List<Object?> get props => [response, dateRange];

  /// Helper methods for quick access to stats
  double get totalRevenue => response.data.financialStats.totalRevenue;

  int get totalBookings => response.data.bookingStats.totalBookings;

  int get totalParkingLots => response.data.summary.totalParkings;

  int get activeBookings => response.data.bookingStats.activeBookings;

  String get occupancyRate => response.data.occupancyStats.occupancyRate;

  /// Check if statistics are available
  bool get hasStats => true; // data is always present (required in response)

  /// Get formatted date range string
  String get dateRangeString {
    if (dateRange == null) return 'All Time';

    final start = dateRange!.startDate;
    final end = dateRange!.endDate;

    // Check if it's today
    final now = DateTime.now();
    if (start.year == now.year &&
        start.month == now.month &&
        start.day == now.day &&
        end.year == now.year &&
        end.month == now.month &&
        end.day == now.day) {
      return 'Today';
    }

    // Check if it's this week
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    if (start.year == weekStart.year &&
        start.month == weekStart.month &&
        start.day == weekStart.day) {
      return 'This Week';
    }

    // Check if it's this month
    if (start.year == now.year &&
        start.month == now.month &&
        start.day == 1) {
      return 'This Month';
    }

    // Check if it's this year
    if (start.year == now.year &&
        start.month == 1 &&
        start.day == 1) {
      return 'This Year';
    }

    // Custom range
    return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
  }
}

/// Error state
class ParkingStatsError extends ParkingStatsState {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const ParkingStatsError({
    required this.message,
    this.statusCode,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, statusCode, errorCode];
}

