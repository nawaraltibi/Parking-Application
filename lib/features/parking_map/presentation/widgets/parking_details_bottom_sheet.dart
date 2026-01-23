import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../../../../core/map/map_point.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/map/map_adapter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/parking_lot_entity.dart';
import '../../domain/entities/parking_details_entity.dart';

/// Parking Details Bottom Sheet
/// Modern bottom sheet inspired by reference designs
/// Shows parking lot details with smooth animations
class ParkingDetailsBottomSheet extends StatefulWidget {
  final ParkingLotEntity selectedLot;
  final ParkingDetailsEntity? details;
  final bool isLoadingDetails;
  final String? errorMessage;
  final ScrollController scrollController;
  final MapController? mapController;
  final MapPoint? userLocation;

  const ParkingDetailsBottomSheet({
    super.key,
    required this.selectedLot,
    required this.scrollController,
    this.details,
    this.isLoadingDetails = false,
    this.errorMessage,
    this.mapController,
    this.userLocation,
  });

  @override
  State<ParkingDetailsBottomSheet> createState() =>
      _ParkingDetailsBottomSheetState();
}

class _ParkingDetailsBottomSheetState extends State<ParkingDetailsBottomSheet> {
  static GeoPoint?
  _lastDrawnRoadDestination; // Track last drawn road (static to share across instances)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Size to content
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content - All in one scrollable column
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parking name
                  Text(
                    widget.selectedLot.lotName,
                    style: AppTextStyles.titleLarge(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.selectedLot.address,
                          style: AppTextStyles.bodyMedium(
                            context,
                          ).copyWith(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Loading or content
                  if (widget.isLoadingDetails)
                    _buildLoadingSkeleton()
                  else if (widget.errorMessage != null)
                    _buildErrorState(context, widget.errorMessage!)
                  else if (widget.details != null)
                    _buildDetailsContent(context, widget.details!)
                  else
                    _buildBasicInfo(context, widget.selectedLot),

                  const SizedBox(height: 16),

                  // Action buttons - Now part of the scrollable content
                  if (widget.details != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: _buildSecondaryButton(
                        context,
                        icon: Icons.directions,
                        label: AppLocalizations.of(context)!.getDirections,
                        onPressed: _handleGetDirections,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Primary CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.details != null
                          ? () {
                              // TODO: Navigate to booking screen
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.parkingCreateButton,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.selectAndPay,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.details != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${widget.details!.hourlyRate.toStringAsFixed(2)} ${AppLocalizations.of(context)!.perHour}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Reduced bottom padding to minimize empty space
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Availability skeleton
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        // Info skeleton
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 20,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Handle get directions button
  Future<void> _handleGetDirections() async {
    if (widget.mapController == null ||
        widget.userLocation == null ||
        widget.details == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.parkingLocationError),
        ),
      );
      return;
    }

    try {
      // Remove previous road if exists
      if (_lastDrawnRoadDestination != null) {
        await widget.mapController!.removeLastRoad();
      }
      if (!mounted) return;

      // Get user location and parking location
      final userGeoPoint = MapAdapter.toGeoPoint(widget.userLocation!);
      final parkingGeoPoint = GeoPoint(
        latitude: widget.details!.latitude,
        longitude: widget.details!.longitude,
      );

      // Try to draw road with retry mechanism (OSRM sometimes fails)
      RoadInfo? roadInfo;
      int retryCount = 0;
      const maxRetries = 2;

      while (retryCount <= maxRetries && mounted) {
        try {
          // Draw road from user location to parking lot
          roadInfo = await widget.mapController!.drawRoad(
            userGeoPoint,
            parkingGeoPoint,
            roadType: RoadType.car,
            roadOption: RoadOption(
              roadColor: AppColors.primary,
              roadWidth: 8,
              zoomInto: true,
            ),
          );
          break; // Success, exit retry loop
        } catch (retryError) {
          retryCount++;
          debugPrint('Retry $retryCount/$maxRetries failed: $retryError');

          if (retryCount > maxRetries) {
            // All retries failed, rethrow the last error
            rethrow;
          }

          // Wait before retrying
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      if (!mounted || roadInfo == null) return;

      _lastDrawnRoadDestination = parkingGeoPoint;

      // Close bottom sheet to show the map with directions
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show success message after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          final distanceKm = (roadInfo!.distance ?? 0).toStringAsFixed(2);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context)!.getDirections}: $distanceKm km',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Error drawing road: $e');
      if (!mounted) return;

      // Check if it's a JSON parsing error from OSRM
      final errorMessage = e.toString().toLowerCase();
      String userMessage;

      if (errorMessage.contains('json') ||
          errorMessage.contains('exit') ||
          errorMessage.contains('parsing')) {
        // OSRM API error - routing service unavailable or invalid response
        userMessage = AppLocalizations.of(context)!.routingServiceError;
      } else if (errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout')) {
        // Network error
        userMessage = AppLocalizations.of(context)!.routingNetworkError;
      } else {
        // Generic error
        userMessage =
            '${AppLocalizations.of(context)!.error}: ${AppLocalizations.of(context)!.routingFailed}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMessage),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(error, style: TextStyle(color: Colors.red[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context, ParkingLotEntity lot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available spaces
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.local_parking, color: Colors.green[700]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lot.availableSpacesCount} / ${lot.totalSpaces}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.availableParkingSpaces,
                      style: TextStyle(fontSize: 12, color: Colors.green[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppLocalizations.of(context)!.available,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Price
        Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              '${lot.hourlyRate.toStringAsFixed(2)} ${AppLocalizations.of(context)!.perHour}',
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    ParkingDetailsEntity details,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available spaces with details
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: details.hasAvailableSpaces
                ? Colors.green[50]
                : Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: details.hasAvailableSpaces
                  ? Colors.green[200]!
                  : Colors.orange[200]!,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_parking,
                color: details.hasAvailableSpaces
                    ? Colors.green[700]
                    : Colors.orange[700],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${details.availableSpacesCount} / ${details.totalSpaces}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: details.hasAvailableSpaces
                            ? Colors.green[700]
                            : Colors.orange[700],
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.availableParkingSpaces,
                      style: TextStyle(
                        fontSize: 12,
                        color: details.hasAvailableSpaces
                            ? Colors.green[600]
                            : Colors.orange[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: details.hasAvailableSpaces
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  details.hasAvailableSpaces
                      ? AppLocalizations.of(context)!.available
                      : AppLocalizations.of(context)!.limited,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Price per hour
        Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              '${details.hourlyRate.toStringAsFixed(2)} ${AppLocalizations.of(context)!.perHour}',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Payment hours (if available)
        Row(
          children: [
            Icon(Icons.payment, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.paymentHoursApply,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
