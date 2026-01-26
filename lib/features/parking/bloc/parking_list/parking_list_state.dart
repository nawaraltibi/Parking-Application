part of 'parking_list_bloc.dart';

/// Base class for parking list states
abstract class ParkingListState extends Equatable {
  const ParkingListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ParkingListInitial extends ParkingListState {
  const ParkingListInitial();
}

/// Loading state
class ParkingListLoading extends ParkingListState {
  final bool isOwnerView; // true for owner's parkings, false for nearby

  const ParkingListLoading({required this.isOwnerView});

  @override
  List<Object?> get props => [isOwnerView];
}

/// Loaded state with parkings data
class ParkingListLoaded extends ParkingListState {
  final ParkingListResponse response;
  final bool isOwnerView;
  final ParkingFilter filter;
  final String? searchQuery;

  const ParkingListLoaded({
    required this.response,
    required this.isOwnerView,
    this.filter = ParkingFilter.all,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [response, isOwnerView, filter, searchQuery];

  /// Get filtered parkings based on filter and search query
  List<dynamic> get filteredParkings {
    final data = response.data;
    if (data.isEmpty) return [];

    var parkings = data;

    // Apply filter using ParkingFilter.matches()
    parkings = parkings.where((p) => filter.matches(p)).toList();

    // Apply search query
    final query = searchQuery;
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      parkings = parkings
          .where((p) =>
              p.lotName.toLowerCase().contains(lowerQuery) ||
              p.address.toLowerCase().contains(lowerQuery))
          .toList();
    }

    return parkings;
  }

  /// Check if list is empty after filtering
  bool get isEmpty => filteredParkings.isEmpty;

  /// Get parkings count after filtering
  int get count => filteredParkings.length;

  /// Get total parkings count (before filtering)
  int get totalCount => response.data.length;
}

/// Error state
class ParkingListError extends ParkingListState {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final bool isOwnerView;

  const ParkingListError({
    required this.message,
    this.statusCode,
    this.errorCode,
    required this.isOwnerView,
  });

  @override
  List<Object?> get props => [message, statusCode, errorCode, isOwnerView];
}

