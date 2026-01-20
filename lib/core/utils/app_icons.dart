import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

/// App Icons Helper
/// Centralized icon management using Bootstrap icons from icons_plus
/// 
/// Rules:
/// - Inactive/default state → Outline icons
/// - Active/selected state → Solid/fill icons
/// - Same icon family everywhere (Bootstrap)
class AppIcons {
  // Bottom Navigation Icons
  static const IconData parkings = Bootstrap.stack;
  static const IconData parkingsSolid = Bootstrap.layers_fill;
  static const IconData profile = Bootstrap.person_circle;
  static const IconData profileSolid = Bootstrap.person_circle;

  // Dashboard & Navigation
  static const IconData dashboard = Bootstrap.pie_chart;
  static const IconData dashboardSolid = Bootstrap.pie_chart_fill;
  static const IconData myParkings = Bootstrap.grid_3x3;
  static const IconData myParkingsSolid = Bootstrap.grid_3x3;

  // Actions
  static const IconData add = Bootstrap.plus_circle;
  static const IconData addSolid = Bootstrap.plus_circle_fill;
  static const IconData edit = Bootstrap.pencil;
  static const IconData editSolid = Bootstrap.pencil_fill;
  static const IconData delete = Bootstrap.trash;
  static const IconData deleteSolid = Bootstrap.trash_fill;
  static const IconData more = Bootstrap.three_dots_vertical;
  static const IconData moreSolid = Bootstrap.three_dots_vertical;

  // Location & Map
  static const IconData location = Bootstrap.geo_alt;
  static const IconData locationSolid = Bootstrap.geo_alt_fill;

  // Financial
  static const IconData currency = Bootstrap.currency_dollar;
  static const IconData currencySolid = Bootstrap.currency_dollar;
  static const IconData revenue = Bootstrap.cash_coin;
  static const IconData revenueSolid = Bootstrap.cash_coin;

  // Status & Info
  static const IconData check = Bootstrap.check_circle;
  static const IconData checkSolid = Bootstrap.check_circle_fill;
  static const IconData warning = Bootstrap.exclamation_triangle;
  static const IconData warningSolid = Bootstrap.exclamation_triangle_fill;
  static const IconData error = Bootstrap.x_circle;
  static const IconData errorSolid = Bootstrap.x_circle_fill;
  static const IconData info = Bootstrap.info_circle;
  static const IconData infoSolid = Bootstrap.info_circle_fill;

  // Parking Specific
  static const IconData parking = Bootstrap.p_square;
  static const IconData parkingSolid = Bootstrap.p_square;
  static const IconData spaces = Bootstrap.grid_3x3;
  static const IconData spacesSolid = Bootstrap.grid_3x3;

  // Booking & Calendar
  static const IconData booking = Bootstrap.calendar;
  static const IconData bookingSolid = Bootstrap.calendar_fill;
  static const IconData clock = Bootstrap.clock;
  static const IconData clockSolid = Bootstrap.clock_fill;

  // Search & Filter
  static const IconData search = Bootstrap.search;
  static const IconData searchSolid = Bootstrap.search;
  static const IconData filter = Bootstrap.funnel;
  static const IconData filterSolid = Bootstrap.funnel_fill;

  // Helper method to get icon based on active state
  static IconData getIcon({
    required IconData outline,
    required IconData solid,
    required bool isActive,
  }) {
    return isActive ? solid : outline;
  }
}
