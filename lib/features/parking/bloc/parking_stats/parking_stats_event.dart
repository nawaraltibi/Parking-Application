part of 'parking_stats_bloc.dart';

/// Base class for parking stats events
abstract class ParkingStatsEvent extends Equatable {
  const ParkingStatsEvent();

  @override
  List<Object?> get props => [];
}

/// Load parking statistics
class LoadParkingStats extends ParkingStatsEvent {
  final DateRange? dateRange;

  const LoadParkingStats({this.dateRange});

  @override
  List<Object?> get props => [dateRange];
}

/// Refresh statistics
class RefreshParkingStats extends ParkingStatsEvent {
  const RefreshParkingStats();
}

/// Filter statistics by date range
class FilterStatsByDateRange extends ParkingStatsEvent {
  final DateRange dateRange;

  const FilterStatsByDateRange(this.dateRange);

  @override
  List<Object?> get props => [dateRange];
}

/// Date range for filtering statistics
class DateRange extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const DateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];

  /// Predefined date ranges
  static DateRange get today {
    final now = DateTime.now();
    return DateRange(
      startDate: DateTime(now.year, now.month, now.day),
      endDate: now,
    );
  }

  static DateRange get thisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return DateRange(
      startDate: DateTime(weekStart.year, weekStart.month, weekStart.day),
      endDate: now,
    );
  }

  static DateRange get thisMonth {
    final now = DateTime.now();
    return DateRange(
      startDate: DateTime(now.year, now.month, 1),
      endDate: now,
    );
  }

  static DateRange get thisYear {
    final now = DateTime.now();
    return DateRange(
      startDate: DateTime(now.year, 1, 1),
      endDate: now,
    );
  }
}

