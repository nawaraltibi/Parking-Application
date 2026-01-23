import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'map_point.dart';
import 'map_marker.dart';

/// Map Adapter
/// Converts domain entities to map-specific types
/// This is the only place where we depend on flutter_osm_plugin
/// To switch map providers, only this file needs to change
class MapAdapter {
  /// Convert MapPoint to GeoPoint (OSM)
  static GeoPoint toGeoPoint(MapPoint point) {
    return GeoPoint(
      latitude: point.latitude,
      longitude: point.longitude,
    );
  }

  /// Convert LocationEntity to GeoPoint (OSM)
  static GeoPoint locationEntityToGeoPoint(dynamic locationEntity) {
    return GeoPoint(
      latitude: locationEntity.latitude,
      longitude: locationEntity.longitude,
    );
  }

  /// Convert ParkingLotEntity to MapPoint
  static MapPoint parkingLotToMapPoint(dynamic parkingLotEntity) {
    return MapPoint(
      latitude: parkingLotEntity.latitude,
      longitude: parkingLotEntity.longitude,
    );
  }

  /// Convert ParkingLotEntity to MapMarker
  static MapMarker parkingLotToMapMarker(dynamic parkingLotEntity) {
    return MapMarker(
      id: parkingLotEntity.lotId.toString(),
      position: parkingLotToMapPoint(parkingLotEntity),
      title: parkingLotEntity.lotName,
      metadata: {
        'lotId': parkingLotEntity.lotId,
        'lotName': parkingLotEntity.lotName,
        'address': parkingLotEntity.address,
        'availableSpaces': parkingLotEntity.availableSpaces,
        'totalSpaces': parkingLotEntity.totalSpaces,
        'hourlyRate': parkingLotEntity.hourlyRate,
        'status': parkingLotEntity.status,
      },
    );
  }

  /// Convert list of ParkingLotEntity to list of MapMarker
  static List<MapMarker> parkingLotsToMapMarkers(List<dynamic> parkingLots) {
    return parkingLots
        .map((lot) => parkingLotToMapMarker(lot))
        .toList();
  }

  /// Convert MapMarker to GeoPoint (OSM)
  static GeoPoint markerToGeoPoint(MapMarker marker) {
    return toGeoPoint(marker.position);
  }

  /// Convert list of MapMarker to list of GeoPoint (OSM)
  static List<GeoPoint> markersToGeoPoints(List<MapMarker> markers) {
    return markers.map((marker) => markerToGeoPoint(marker)).toList();
  }
}

