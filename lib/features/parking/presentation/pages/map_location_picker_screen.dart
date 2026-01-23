import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';

/// Map Location Picker Screen
/// 
/// A modern, clean map picker screen using flutter_osm_plugin.
/// Features:
/// - Fixed center marker: User pans the map underneath a fixed centered marker
/// - Source of truth: Map camera position (not GPS location)
/// - Tracks center on map movements using OSMMixinObserver
/// - Smooth user location centering
/// - Proper error handling and loading states
class MapLocationPickerScreen extends StatefulWidget {
  /// Initial latitude (for edit mode)
  final double? initialLatitude;
  
  /// Initial longitude (for edit mode)
  final double? initialLongitude;

  const MapLocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<MapLocationPickerScreen> createState() =>
      _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen>
    with OSMMixinObserver {
  MapController? _mapController;
  bool _isLoading = true;
  bool _mapIsReady = false;
  bool _isDisposed = false;
  PermissionStatus _permissionStatus = PermissionStatus.denied;
  String? _errorMessage;

  /// Default fallback location (Damascus, Syria)
  static GeoPoint get _defaultLocation => GeoPoint(
        latitude: 33.5138,
        longitude: 36.2765,
      );

  /// Source of truth: Current map center (where the fixed pin points)
  /// Updated via onRegionChanged callback from OSMMixinObserver
  GeoPoint? _currentMapCenter;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _mapController?.listenerRegionIsChanging.removeListener(_onRegionChanging);
    _mapController?.removeObserver(this);
    _mapController?.dispose();
    super.dispose();
  }

  /// Initialize map controller based on edit/create mode
  /// Uses MapController.withUserPosition() for user location
  /// Uses MapController.withPosition() for fixed position
  Future<void> _initializeMap() async {
    try {
      final isEditMode =
          widget.initialLatitude != null && widget.initialLongitude != null;

      if (isEditMode) {
        // EDIT MODE: Use provided coordinates with MapController.withPosition()
        final point = GeoPoint(
          latitude: widget.initialLatitude!,
          longitude: widget.initialLongitude!,
        );

        _mapController = MapController.withPosition(
          initPosition: point,
        );
        _currentMapCenter = point;
      } else {
        // CREATE MODE: Request permission and use user location or default
        await _requestLocationPermission();

        if (_permissionStatus.isGranted) {
          // Use MapController.withUserPosition() to start at user location
          _mapController = MapController.withUserPosition(
            trackUserLocation: const UserTrackingOption(
              enableTracking: false,
              unFollowUser: true, // Allow user to pan away from their location
            ),
          );
        } else {
          // Permission denied: Use default location with MapController.withPosition()
          _mapController = MapController.withPosition(
            initPosition: _defaultLocation,
          );
        }
        _currentMapCenter = _defaultLocation;
      }

      // Register observer to receive map events
      _mapController?.addObserver(this);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to initialize map: ${e.toString()}';
        });
      }
    }
  }

  /// Request location permission
  Future<void> _requestLocationPermission() async {
    try {
      _permissionStatus = await Permission.location.request();
      
      if (_permissionStatus.isPermanentlyDenied) {
        if (mounted) {
          UnifiedSnackbar.show(
            context,
            message: 'Location permission is permanently denied. Please enable it in settings.',
            type: SnackbarType.warning,
          );
        }
      }
    } catch (e) {
      _permissionStatus = PermissionStatus.denied;
      if (mounted) {
        debugPrint('MapLocationPickerScreen: Error requesting permission: $e');
      }
    }
  }

  /// Handle map ready callback from OSMMixinObserver
  @override
  Future<void> mapIsReady(bool isReady) async {
    if (!isReady || _mapIsReady || _isDisposed) return;

    if (mounted) {
      setState(() {
        _mapIsReady = true;
      });
    }

    // Get initial center point once map is ready
    if (_mapController != null) {
      try {
        _currentMapCenter = await _mapController!.centerMap;
        if (kDebugMode) {
          debugPrint('MapLocationPickerScreen: Initial center set -> '
              '${_currentMapCenter!.latitude}, ${_currentMapCenter!.longitude}');
        }
      } catch (e) {
        debugPrint('MapLocationPickerScreen: Error getting initial center: $e');
      }
      
      // Also setup listenerRegionIsChanging as a backup/additional tracking method
      _mapController!.listenerRegionIsChanging.addListener(_onRegionChanging);
    }

    // Center on user location if permission granted (CREATE mode only)
    if (_permissionStatus.isGranted && 
        widget.initialLatitude == null && 
        _mapController != null) {
      _centerOnUserLocation();
    } else if (widget.initialLatitude != null && 
               widget.initialLongitude != null &&
               _mapController != null) {
      // EDIT MODE: Ensure we're centered on initial position
      _centerOnInitialPosition();
    }
  }
  
  /// Additional listener for region changes (backup method)
  /// This ensures we track map center even if onRegionChanged doesn't fire
  Future<void> _onRegionChanging() async {
    if (_isDisposed || _mapController == null || !mounted) return;
    
    try {
      final center = await _mapController!.centerMap;
      
      // Only update if coordinates actually changed
      if (_currentMapCenter == null ||
          (_currentMapCenter!.latitude != center.latitude ||
           _currentMapCenter!.longitude != center.longitude)) {
        _currentMapCenter = center;
        
        if (kDebugMode) {
          debugPrint('MapLocationPickerScreen: Region changing -> '
              '${center.latitude}, ${center.longitude}');
        }
      }
    } catch (e) {
      // Silently ignore errors to avoid spam
    }
  }

  /// Center map on user's current location
  Future<void> _centerOnUserLocation() async {
    if (_mapController == null || _isDisposed) return;

    try {
      // Get user location using Geolocator for more reliable results
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      final userPoint = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await _mapController!.goToLocation(userPoint);
      _currentMapCenter = userPoint;
      
      if (mounted) {
        debugPrint('MapLocationPickerScreen: Centered on user location: '
            '${userPoint.latitude}, ${userPoint.longitude}');
      }
    } catch (e) {
      // If user location fails, use default location
      if (mounted) {
        debugPrint('MapLocationPickerScreen: Failed to get user location: $e');
        await _mapController!.goToLocation(_defaultLocation);
        _currentMapCenter = _defaultLocation;
      }
    }
  }

  /// Center map on initial position (edit mode)
  Future<void> _centerOnInitialPosition() async {
    if (_mapController == null || _isDisposed) return;

    try {
      final initialPoint = GeoPoint(
        latitude: widget.initialLatitude!,
        longitude: widget.initialLongitude!,
      );
      await _mapController!.goToLocation(initialPoint);
      _currentMapCenter = initialPoint;
    } catch (e) {
      if (mounted) {
        debugPrint('MapLocationPickerScreen: Error centering on initial position: $e');
      }
    }
  }

  /// Track map center when region changes (pan/drag/zoom)
  /// This is called automatically by OSMMixinObserver when map camera moves
  @override
  void onRegionChanged(Region region) {
    super.onRegionChanged(region);
    
    if (_isDisposed || !mounted) return;

    // Update the tracked center from the region
    // Note: This callback fires very frequently during panning (normal behavior)
    final newCenter = region.center;
    
    // Only update if coordinates actually changed (avoid unnecessary updates)
    if (_currentMapCenter == null ||
        (_currentMapCenter!.latitude != newCenter.latitude ||
         _currentMapCenter!.longitude != newCenter.longitude)) {
      _currentMapCenter = newCenter;
      
      if (kDebugMode) {
        debugPrint('MapLocationPickerScreen: Center updated -> '
            '${newCenter.latitude}, ${newCenter.longitude}');
      }
    }
  }

  /// Handle "My Location" button press
  /// Moves the map smoothly to the user's current location
  Future<void> _goToMyLocation() async {
    if (!_mapIsReady || _mapController == null || _isDisposed) return;

    // Request permission if not granted
    if (!_permissionStatus.isGranted) {
      await _requestLocationPermission();
    }

    if (!_permissionStatus.isGranted) {
      if (mounted) {
        UnifiedSnackbar.show(
          context,
          message: 'Location permission is required to use this feature.',
          type: SnackbarType.warning,
        );
      }
      return;
    }

    try {
      // Get user location using Geolocator for reliable results
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      final userPoint = GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      
      // Move map to user location
      await _mapController!.goToLocation(userPoint);
      _currentMapCenter = userPoint;
      
      if (mounted) {
        debugPrint('MapLocationPickerScreen: Moved to my location: '
            '${userPoint.latitude}, ${userPoint.longitude}');
      }
    } catch (e) {
      if (mounted) {
        UnifiedSnackbar.show(
          context,
          message: 'Failed to get your location. Please try again.',
          type: SnackbarType.error,
        );
        debugPrint('MapLocationPickerScreen: Error getting location: $e');
      }
    }
  }

  /// Confirm location selection
  /// Returns the current map center (what's under the fixed pin)
  /// Uses the tracked center from onRegionChanged for accuracy
  Future<void> _confirmLocation() async {
    if (!_mapIsReady || _mapController == null || _isDisposed || !mounted) {
      return;
    }

    try {
      // First, try to get the latest center from the map controller
      final mapCenter = await _mapController!.centerMap;
      
      // Use the most recent value (either from controller or tracked)
      final finalCenter = _currentMapCenter ?? mapCenter;
      
      if (kDebugMode) {
        debugPrint('MapLocationPickerScreen: Confirming location -> '
            'Lat: ${finalCenter.latitude}, Lon: ${finalCenter.longitude}');
        debugPrint('MapLocationPickerScreen: Tracked center -> '
            '${_currentMapCenter?.latitude}, ${_currentMapCenter?.longitude}');
        debugPrint('MapLocationPickerScreen: Controller center -> '
            '${mapCenter.latitude}, ${mapCenter.longitude}');
      }
      
      if (mounted) {
        Navigator.of(context).pop(finalCenter);
      }
    } catch (e) {
      debugPrint('MapLocationPickerScreen: Error getting center: $e');
      
      // Fallback: Use tracked center if centerMap fails
      if (_currentMapCenter != null) {
        if (kDebugMode) {
          debugPrint('MapLocationPickerScreen: Using tracked center (fallback): '
              '${_currentMapCenter!.latitude}, ${_currentMapCenter!.longitude}');
        }
        if (mounted) {
          Navigator.of(context).pop(_currentMapCenter);
        }
      } else {
        if (mounted) {
          UnifiedSnackbar.show(
            context,
            message: 'Failed to get location. Please try again.',
            type: SnackbarType.error,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(EvaIcons.navigation2),
            tooltip: 'Center on my location',
            onPressed: _mapIsReady ? _goToMyLocation : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map widget or loading/error state
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          else if (_errorMessage != null)
            Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      EvaIcons.alertCircleOutline,
                      size: 64.sp,
                      color: AppColors.error,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Error',
                      style: AppTextStyles.titleLarge(context),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    CustomElevatedButton(
                      title: 'Retry',
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isLoading = true;
                        });
                        _initializeMap();
                      },
                    ),
                  ],
                ),
              ),
            )
          else if (_mapController != null)
            OSMFlutter(
              controller: _mapController!,
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(
                  enableTracking: false,
                  unFollowUser: false,
                ),
                zoomOption: const ZoomOption(
                  initZoom: 15.0,
                  minZoomLevel: 3.0,
                  maxZoomLevel: 19.0,
                  stepZoom: 1.0,
                ),
                roadConfiguration: RoadOption(
                  roadColor: AppColors.primary,
                ),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(
                    icon: Icon(
                      EvaIcons.person,
                      color: AppColors.primary,
                      size: 48,
                    ),
                  ),
                  directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                      EvaIcons.arrowUpward,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                ),
              ),
              onMapIsReady: mapIsReady,
              // Track map center when user taps
              onGeoPointClicked: (GeoPoint point) {
                if (!_isDisposed && mounted) {
                  _currentMapCenter = point;
                  debugPrint('MapLocationPickerScreen: Point clicked -> '
                      '${point.latitude}, ${point.longitude}');
                }
              },
            ),

          // Fixed center pin - always at screen center
          // MUST use IgnorePointer to not block map gestures
          if (!_isLoading && _errorMessage == null)
            Center(
              child: IgnorePointer(
                child: Icon(
                  EvaIcons.pin,
                  size: 48.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: CustomElevatedButton(
            title: 'Confirm Location',
            onPressed: _mapIsReady ? _confirmLocation : null,
          ),
        ),
      ),
    );
  }
}
