part of 'parking_list_bloc.dart';

/// Base class for parking list events
abstract class ParkingListEvent extends Equatable {
  const ParkingListEvent();

  @override
  List<Object?> get props => [];
}

/// Load parking lots for the owner
class LoadOwnerParkings extends ParkingListEvent {
  const LoadOwnerParkings();
}

/// Load nearby parking lots for users
class LoadNearbyParkings extends ParkingListEvent {
  final double latitude;
  final double longitude;
  final double radius; // in kilometers

  const LoadNearbyParkings({
    required this.latitude,
    required this.longitude,
    this.radius = 5.0,
  });

  @override
  List<Object?> get props => [latitude, longitude, radius];
}

/// Filter parking lots by type/status
class FilterParkings extends ParkingListEvent {
  final ParkingFilter filter;

  const FilterParkings(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Search parking lots by name/location
class SearchParkings extends ParkingListEvent {
  final String query;

  const SearchParkings(this.query);

  @override
  List<Object?> get props => [query];
}

/// Refresh current parkings list
class RefreshParkings extends ParkingListEvent {
  const RefreshParkings();
}

