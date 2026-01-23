import 'map_point.dart';

/// Map Marker
/// Abstraction for a map marker with ID and position
/// Independent of map provider
class MapMarker {
  final String id;
  final MapPoint position;
  final String? title;
  final Map<String, dynamic>? metadata; // Additional data (e.g., parking lot info)

  const MapMarker({
    required this.id,
    required this.position,
    this.title,
    this.metadata,
  });

  /// Create a copy of MapMarker with updated fields
  MapMarker copyWith({
    String? id,
    MapPoint? position,
    String? title,
    Map<String, dynamic>? metadata,
  }) {
    return MapMarker(
      id: id ?? this.id,
      position: position ?? this.position,
      title: title ?? this.title,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MapMarker && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MapMarker(id: $id, position: $position, title: $title)';
  }
}

