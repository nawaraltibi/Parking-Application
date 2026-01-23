import 'package:flutter/material.dart';

/// Utility class to map Color objects to color names
class ColorNameMapper {
  /// Maps a Color to the closest matching color name
  /// Returns the name of the color that best matches the given Color object
  static String mapColorToName(Color color) {
    // Convert color to RGB
    final r = color.red;
    final g = color.green;
    final b = color.blue;

    // Define color mappings with RGB values
    final colorMap = <String, Color>{
      'Black': const Color(0xFF000000),
      'White': const Color(0xFFFFFFFF),
      'Silver': const Color(0xFFC0C0C0),
      'Gray': const Color(0xFF808080),
      'Blue': const Color(0xFF0000FF),
      'Red': const Color(0xFFFF0000),
      'Green': const Color(0xFF008000),
      'Brown': const Color(0xFFA52A2A),
      'Beige': const Color(0xFFF5F5DC),
      'Gold': const Color(0xFFFFD700),
      'Yellow': const Color(0xFFFFFF00),
      'Orange': const Color(0xFFFFA500),
      'Purple': const Color(0xFF800080),
      'Pink': const Color(0xFFFFC0CB),
      'Maroon': const Color(0xFF800000),
      'Navy': const Color(0xFF000080),
      'Burgundy': const Color(0xFF800020),
      'Teal': const Color(0xFF008080),
    };

    // Find the closest matching color using Euclidean distance in RGB space
    String closestColor = 'Black';
    double minDistance = double.infinity;

    for (final entry in colorMap.entries) {
      final refColor = entry.value;
      final distance = _colorDistance(
        r, g, b,
        refColor.red, refColor.green, refColor.blue,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestColor = entry.key;
      }
    }

    return closestColor;
  }

  /// Maps a color name to a Color object
  /// Returns the Color object for the given color name, or Black as default
  static Color mapNameToColor(String colorName) {
    final colorMap = <String, Color>{
      'Black': const Color(0xFF000000),
      'White': const Color(0xFFFFFFFF),
      'Silver': const Color(0xFFC0C0C0),
      'Gray': const Color(0xFF808080),
      'Blue': const Color(0xFF0000FF),
      'Red': const Color(0xFFFF0000),
      'Green': const Color(0xFF008000),
      'Brown': const Color(0xFFA52A2A),
      'Beige': const Color(0xFFF5F5DC),
      'Gold': const Color(0xFFFFD700),
      'Yellow': const Color(0xFFFFFF00),
      'Orange': const Color(0xFFFFA500),
      'Purple': const Color(0xFF800080),
      'Pink': const Color(0xFFFFC0CB),
      'Maroon': const Color(0xFF800000),
      'Navy': const Color(0xFF000080),
      'Burgundy': const Color(0xFF800020),
      'Teal': const Color(0xFF008080),
    };

    return colorMap[colorName] ?? const Color(0xFF000000);
  }

  /// Calculate Euclidean distance between two colors in RGB space
  static double _colorDistance(int r1, int g1, int b1, int r2, int g2, int b2) {
    final dr = r1 - r2;
    final dg = g1 - g2;
    final db = b1 - b2;
    return (dr * dr + dg * dg + db * db).toDouble();
  }
}

