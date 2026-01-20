import 'package:flutter/material.dart';
import 'storage_service.dart';

/// Language Service
/// Manages app language selection and persistence
/// 
/// Features:
/// - Default language is English
/// - Persists language choice using SharedPreferences
/// - Supports English and Arabic
class LanguageService {
  static const String _languageKey = 'app_language';
  static const String _defaultLanguage = 'en'; // English is default

  /// Get the current app language
  /// Returns 'en' (English) as default if no language is stored
  static String getLanguage() {
    return StorageService.getString(_languageKey) ?? _defaultLanguage;
  }

  /// Set the app language
  /// Saves the language code to SharedPreferences
  static Future<bool> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'ar') {
      return false; // Only support English and Arabic
    }
    return await StorageService.setString(_languageKey, languageCode);
  }

  /// Get the current locale
  /// Returns English locale as default
  static Locale getLocale() {
    final languageCode = getLanguage();
    return Locale(languageCode);
  }

  /// Set the locale
  /// Extracts language code and saves it
  static Future<bool> setLocale(Locale locale) async {
    return await setLanguage(locale.languageCode);
  }

  /// Check if current language is English
  static bool isEnglish() {
    return getLanguage() == 'en';
  }

  /// Check if current language is Arabic
  static bool isArabic() {
    return getLanguage() == 'ar';
  }

  /// Reset to default language (English)
  static Future<bool> resetToDefault() async {
    return await setLanguage(_defaultLanguage);
  }
}

