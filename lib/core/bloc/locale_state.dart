part of 'locale_cubit.dart';

/// Locale State
/// Represents the current locale of the application
class LocaleState {
  final Locale locale;

  const LocaleState({
    required this.locale,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocaleState && other.locale == locale;
  }

  @override
  int get hashCode => locale.hashCode;

  @override
  String toString() => 'LocaleState(locale: $locale)';
}

