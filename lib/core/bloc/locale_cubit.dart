import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/language_service.dart';

part 'locale_state.dart';

/// Locale Cubit
/// Manages app locale state and provides a single source of truth for locale changes
/// 
/// Features:
/// - Initializes with locale from LanguageService (persisted in SharedPreferences)
/// - Provides method to change locale that persists to SharedPreferences
/// - Emits new locale state immediately for MaterialApp to rebuild
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(LocaleState(locale: LanguageService.getLocale())) {
    // Initialize with persisted locale
    _loadLocale();
  }

  /// Load locale from persistence
  void _loadLocale() {
    final locale = LanguageService.getLocale();
    emit(LocaleState(locale: locale));
  }

  /// Change the app locale
  /// 
  /// This method:
  /// 1. Saves the new locale to SharedPreferences via LanguageService
  /// 2. Emits the new locale state immediately
  /// 3. MaterialApp will rebuild automatically when state changes
  Future<void> changeLocale(Locale newLocale) async {
    // Save to SharedPreferences first
    final success = await LanguageService.setLocale(newLocale);
    
    if (success) {
      // Emit new state immediately - this will trigger MaterialApp rebuild
      emit(LocaleState(locale: newLocale));
    }
  }

  /// Change locale by language code
  Future<void> changeLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'ar') {
      return; // Only support English and Arabic
    }
    await changeLocale(Locale(languageCode));
  }

  /// Get current locale
  Locale get currentLocale => state.locale;
}

