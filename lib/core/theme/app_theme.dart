import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';

/// App Theme Configuration
/// Provides light and dark theme configurations using blue-based color palette
class AppTheme {
  /// Light Theme
  static ThemeData get lightTheme => ThemeData(
        // Primary Colors
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,

        // Default Font Family - Cairo (supports both Arabic and Latin)
        // Flutter automatically handles RTL/LTR and font selection based on text content
        fontFamily: 'Cairo',

        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.textOnPrimary,
          secondary: AppColors.accent,
          onSecondary: AppColors.brightWhite,
          error: AppColors.error,
          onError: AppColors.brightWhite,
          surface: AppColors.brightWhite,
          onSurface: AppColors.secondaryText,
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          surfaceTintColor: AppColors.brightWhite,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColors.brightWhite,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),

        // Icons
        iconTheme: IconThemeData(color: AppColors.icon),

        // Dividers & Borders
        dividerColor: AppColors.border,

        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.brightWhite,
        ),

        // Elevated Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.brightWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Input Fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.brightWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.secondaryBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),

        // Typography - Configured with proper weights for modern, balanced look
        textTheme: const TextTheme(
          // Display styles - Largest text, heaviest weight
          displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.w600, // SemiBold
            letterSpacing: -0.25,
          ),
          displayMedium: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w600, // SemiBold
            letterSpacing: 0,
          ),
          displaySmall: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600, // SemiBold
            letterSpacing: 0,
          ),

          // Headline styles - Section headers, heavier weight
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600, // SemiBold
            letterSpacing: 0,
          ),
          headlineMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600, // SemiBold
            letterSpacing: 0,
          ),
          headlineSmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600, // SemiBold
            letterSpacing: 0,
          ),

          // Title styles - Card titles, list headers, medium weight
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: 0,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: 0.1,
          ),

          // Body styles - Main content, regular weight
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400, // Regular
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400, // Regular
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400, // Regular
            letterSpacing: 0.4,
          ),

          // Label styles - Buttons, captions, medium weight
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: 0.1,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: 0.5,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500, // Medium
            letterSpacing: 0.5,
          ),
        ),
      );
}

