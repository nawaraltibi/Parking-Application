part of 'parking_map_bloc.dart';

/// Parking Map State
/// Single unified state class with copyWith for scalability
class ParkingMapState {
  // Map data
  final List<ParkingLotEntity> parkingLots;
  final MapPoint? userLocation;
  
  // Selection
  final ParkingLotEntity? selectedLot;
  final ParkingDetailsEntity? selectedDetails;
  
  // Loading states
  final bool isLoadingParkingLots;
  final bool isLoadingDetails;
  final bool isLoadingLocation;
  
  // Error states
  final String? errorMessage;
  final int? errorStatusCode;
  final String? detailsErrorMessage;
  final int? detailsErrorStatusCode;

  const ParkingMapState({
    this.parkingLots = const [],
    this.userLocation,
    this.selectedLot,
    this.selectedDetails,
    this.isLoadingParkingLots = false,
    this.isLoadingDetails = false,
    this.isLoadingLocation = false,
    this.errorMessage,
    this.errorStatusCode,
    this.detailsErrorMessage,
    this.detailsErrorStatusCode,
  });

  /// Initial state
  factory ParkingMapState.initial() {
    return const ParkingMapState();
  }

  /// Loading state for parking lots
  factory ParkingMapState.loadingParkingLots({
    MapPoint? userLocation,
    List<ParkingLotEntity>? previousParkingLots,
  }) {
    return ParkingMapState(
      parkingLots: previousParkingLots ?? const [],
      userLocation: userLocation,
      isLoadingParkingLots: true,
    );
  }

  /// Loaded state with parking lots
  factory ParkingMapState.loaded({
    required List<ParkingLotEntity> parkingLots,
    MapPoint? userLocation,
  }) {
    return ParkingMapState(
      parkingLots: parkingLots,
      userLocation: userLocation,
      isLoadingParkingLots: false,
    );
  }

  /// Error state
  factory ParkingMapState.error({
    required String message,
    required int statusCode,
    MapPoint? userLocation,
    List<ParkingLotEntity>? parkingLots,
  }) {
    return ParkingMapState(
      errorMessage: message,
      errorStatusCode: statusCode,
      userLocation: userLocation,
      parkingLots: parkingLots ?? const [],
      isLoadingParkingLots: false,
    );
  }

  /// Create a copy with updated fields
  ParkingMapState copyWith({
    List<ParkingLotEntity>? parkingLots,
    MapPoint? userLocation,
    ParkingLotEntity? selectedLot,
    ParkingDetailsEntity? selectedDetails,
    bool? isLoadingParkingLots,
    bool? isLoadingDetails,
    bool? isLoadingLocation,
    String? errorMessage,
    int? errorStatusCode,
    String? detailsErrorMessage,
    int? detailsErrorStatusCode,
    bool clearSelectedLot = false,
    bool clearSelectedDetails = false,
    bool clearError = false,
    bool clearDetailsError = false,
  }) {
    return ParkingMapState(
      parkingLots: parkingLots ?? this.parkingLots,
      userLocation: userLocation ?? this.userLocation,
      selectedLot: clearSelectedLot ? null : (selectedLot ?? this.selectedLot),
      selectedDetails: clearSelectedDetails
          ? null
          : (selectedDetails ?? this.selectedDetails),
      isLoadingParkingLots:
          isLoadingParkingLots ?? this.isLoadingParkingLots,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      errorStatusCode:
          clearError ? null : (errorStatusCode ?? this.errorStatusCode),
      detailsErrorMessage: clearDetailsError
          ? null
          : (detailsErrorMessage ?? this.detailsErrorMessage),
      detailsErrorStatusCode: clearDetailsError
          ? null
          : (detailsErrorStatusCode ?? this.detailsErrorStatusCode),
    );
  }

  /// Check if parking lots are loaded
  bool get hasParkingLots => parkingLots.isNotEmpty;

  /// Check if there's an error
  bool get hasError => errorMessage != null;

  /// Check if details are loaded
  bool get hasDetails => selectedDetails != null;

  /// Check if a lot is selected
  bool get hasSelection => selectedLot != null;

  /// Check if currently loading anything
  bool get isLoading =>
      isLoadingParkingLots || isLoadingDetails || isLoadingLocation;
}
