import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../core/map/map_adapter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/parking_lot_entity.dart';
import '../bloc/parking_map_bloc.dart';
import '../widgets/parking_details_bottom_sheet.dart';

/// Parking Map Screen
/// Displays parking lots on a map with bottom sheet for details
class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen>
    with OSMMixinObserver, TickerProviderStateMixin {
  MapController? _mapController;
  bool _mapIsReady = false;
  GeoPoint? _initialCenter;
  bool _hasCenteredOnUserLocation = false; // Track if we've already centered
  GeoPoint? _lastUserLocation;
  bool _isBottomSheetOpen = false; // Track if bottom sheet is open
  final Map<int, AnimationController> _markerAnimationControllers =
      {}; // Track marker animations

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    // Default center (can be overridden by user location)
    _initialCenter = GeoPoint(
      latitude: 33.5138, // Damascus, Syria
      longitude: 36.2765,
    );

    _mapController = MapController(initPosition: _initialCenter!);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    // Dispose all marker animation controllers
    for (var controller in _markerAnimationControllers.values) {
      controller.dispose();
    }
    _markerAnimationControllers.clear();
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady && mounted) {
      setState(() {
        _mapIsReady = isReady;
      });
    }
  }

  /// Center map on user location (only once on initial load)
  Future<void> _centerOnUserLocation(
    GeoPoint userLocation, {
    bool force = false,
  }) async {
    if (_mapController == null || !_mapIsReady) return;

    // Only center automatically on first load, unless forced (by button)
    if (!force && _hasCenteredOnUserLocation) return;

    // Check if location actually changed
    if (!force && _lastUserLocation != null) {
      final latDiff = (userLocation.latitude - _lastUserLocation!.latitude)
          .abs();
      final lngDiff = (userLocation.longitude - _lastUserLocation!.longitude)
          .abs();
      if (latDiff < 0.0001 && lngDiff < 0.0001) {
        return; // Same location, don't center again
      }
    }

    try {
      // flutter_osm_plugin: goToLocation is deprecated; use moveTo
      await _mapController!.moveTo(userLocation, animate: true);
      _hasCenteredOnUserLocation = true;
      _lastUserLocation = userLocation;
    } catch (e) {
      debugPrint('Error centering on user location: $e');
    }
  }

  /// Go to my location button handler
  Future<void> _goToMyLocation() async {
    final state = context.read<ParkingMapBloc>().state;
    if (state.userLocation != null) {
      final userLocation = MapAdapter.toGeoPoint(state.userLocation!);
      await _centerOnUserLocation(userLocation, force: true);
    } else {
      // If no location, request it
      context.read<ParkingMapBloc>().add(LoadUserLocation());
    }
  }

  /// Add parking lot markers to map with selection support
  Future<void> _addParkingMarkers(
    List<dynamic> parkingLots,
    int? selectedLotId,
  ) async {
    if (_mapController == null || !_mapIsReady) return;

    try {
      // Initialize animation controllers for new markers
      for (final lot in parkingLots) {
        if (!_markerAnimationControllers.containsKey(lot.lotId)) {
          _markerAnimationControllers[lot.lotId] = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          );
        }
      }

      // Remove animation controllers for markers that no longer exist
      final existingLotIds = parkingLots.map((lot) => lot.lotId).toSet();
      final controllersToRemove = _markerAnimationControllers.keys
          .where((id) => !existingLotIds.contains(id))
          .toList();
      for (final id in controllersToRemove) {
        _markerAnimationControllers[id]?.dispose();
        _markerAnimationControllers.remove(id);
      }

      // Add markers for each parking lot
      for (final lot in parkingLots) {
        final marker = MapAdapter.parkingLotToMapMarker(lot);
        final geoPoint = MapAdapter.markerToGeoPoint(marker);
        final isSelected = selectedLotId != null && lot.lotId == selectedLotId;

        // Large parking icon with better visibility
        await _mapController!.addMarker(
          geoPoint,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.local_parking,
              color: AppColors.primary,
              size: isSelected ? 72 : 64, // Much larger size
            ),
          ),
        );

        // Animate marker when selected
        if (isSelected) {
          _markerAnimationControllers[lot.lotId]?.forward().then((_) {
            _markerAnimationControllers[lot.lotId]?.reverse();
          });
        }
      }
    } catch (e) {
      debugPrint('Error adding parking markers: $e');
    }
  }

  /// Find parking lot near clicked point and select it
  void _handleMapTap(GeoPoint point, List<dynamic> parkingLots) {
    if (parkingLots.isEmpty) {
      // If tapping empty map, deselect
      context.read<ParkingMapBloc>().add(DeselectParkingLot());
      return;
    }

    // Find nearest parking lot within reasonable distance
    // Increased threshold for better tap detection
    const threshold = 0.001; // Approximate 100 meters in degrees
    ParkingLotEntity? nearestLot;
    double? nearestDistance;

    for (final lot in parkingLots) {
      final latDiff = (lot.latitude - point.latitude).abs();
      final lngDiff = (lot.longitude - point.longitude).abs();
      final distance = latDiff + lngDiff; // Simple distance calculation

      if (distance < threshold) {
        if (nearestLot == null ||
            distance < (nearestDistance ?? double.infinity)) {
          nearestLot = lot;
          nearestDistance = distance;
        }
      }
    }

    if (nearestLot != null) {
      // Found a parking lot near the tap - animate marker
      final controller = _markerAnimationControllers[nearestLot.lotId];
      if (controller != null) {
        controller.forward().then((_) {
          controller.reverse();
        });
      }
      // Select parking lot
      context.read<ParkingMapBloc>().add(
        SelectParkingLot(lotId: nearestLot.lotId),
      );
    } else {
      // If no parking lot found near tap, deselect
      context.read<ParkingMapBloc>().add(DeselectParkingLot());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.parkingMapTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: AppLocalizations.of(context)!.goToMyLocation,
            onPressed: _goToMyLocation,
          ),
        ],
      ),
      body: BlocConsumer<ParkingMapBloc, ParkingMapState>(
        listener: (context, state) {
          // Handle user location updates (only center once on initial load)
          if (state.userLocation != null && !_hasCenteredOnUserLocation) {
            final userLocation = MapAdapter.toGeoPoint(state.userLocation!);
            _centerOnUserLocation(userLocation);
          }

          // Handle parking lots updates
          if (state.hasParkingLots) {
            _addParkingMarkers(state.parkingLots, state.selectedLot?.lotId);
          }

          // Handle bottom sheet display
          if (state.hasSelection && !_isBottomSheetOpen) {
            // Open bottom sheet when a parking lot is selected
            _showBottomSheet(context, state);
          } else if (!state.hasSelection && _isBottomSheetOpen) {
            // Close bottom sheet when selection is cleared
            Navigator.of(context).pop();
            _isBottomSheetOpen = false;
          }
          // Note: If bottom sheet is already open and details are loaded,
          // BlocBuilder inside the sheet will update it automatically
        },
        builder: (context, state) {
          return _buildMapView(context, state);
        },
      ),
    );
  }

  Widget _buildMapView(BuildContext context, ParkingMapState state) {
    // Show loading state
    if (state.isLoadingParkingLots && !state.hasParkingLots) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (state.hasError && !state.hasParkingLots) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '${AppLocalizations.of(context)!.error}: ${state.errorMessage}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ParkingMapBloc>().add(LoadParkingLots());
              },
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (!state.isLoadingParkingLots &&
        !state.hasParkingLots &&
        !state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_parking_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.noParkingLotsFound),
          ],
        ),
      );
    }

    // Show map
    if (_mapController != null) {
      return OSMFlutter(
        controller: _mapController!,
        osmOption: OSMOption(
          userTrackingOption: const UserTrackingOption(
            enableTracking: false,
            unFollowUser: true,
          ),
          zoomOption: const ZoomOption(
            initZoom: 15.0,
            minZoomLevel: 3.0,
            maxZoomLevel: 19.0,
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            personMarker: const MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: Colors.red, // Red pin for user location
                size: 48,
              ),
            ),
            directionArrowMarker: const MarkerIcon(
              icon: Icon(Icons.arrow_upward, color: Colors.red, size: 32),
            ),
          ),
        ),
        onMapIsReady: mapIsReady,
        onGeoPointClicked: (GeoPoint point) {
          // Handle map tap - check if near a parking lot or deselect
          if (state.hasParkingLots) {
            _handleMapTap(point, state.parkingLots);
          }
        },
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  /// Show bottom sheet using showModalBottomSheet
  void _showBottomSheet(BuildContext context, ParkingMapState state) {
    if (!state.hasSelection || _isBottomSheetOpen) return;

    _isBottomSheetOpen = true;
    final bloc = context.read<ParkingMapBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: bloc, // Provide the bloc to the bottom sheet context
        child: DraggableScrollableSheet(
          initialChildSize: 0.55, // Higher initial position
          minChildSize: 0.50, // Lower minimum to allow more scrolling
          maxChildSize: 0.55,
          builder: (sheetContext, scrollController) {
            // Use BlocBuilder to rebuild when state changes
            return BlocBuilder<ParkingMapBloc, ParkingMapState>(
              builder: (blocContext, currentState) {
                if (!currentState.hasSelection) {
                  // If selection is cleared, close the sheet
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Navigator.of(bottomSheetContext).canPop()) {
                      Navigator.of(bottomSheetContext).pop();
                    }
                  });
                  return const SizedBox.shrink();
                }

                return ParkingDetailsBottomSheet(
                  selectedLot: currentState.selectedLot!,
                  details: currentState.selectedDetails,
                  isLoadingDetails: currentState.isLoadingDetails,
                  errorMessage: currentState.detailsErrorMessage,
                  scrollController: scrollController,
                  mapController: _mapController,
                  userLocation: currentState.userLocation,
                );
              },
            );
          },
        ),
      ),
    ).then((_) {
      // When bottom sheet is dismissed, deselect parking lot
      if (_isBottomSheetOpen) {
        _isBottomSheetOpen = false;
        if (!mounted) return;
        // Avoid using BuildContext across async gap
        bloc.add(DeselectParkingLot());
      }
    });
  }
}
