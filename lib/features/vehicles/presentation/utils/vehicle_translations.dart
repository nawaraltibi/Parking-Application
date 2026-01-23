import '../../../../l10n/app_localizations.dart';

/// Helper class for vehicle-related translations
/// Handles translation of car makes and colors based on locale
class VehicleTranslations {
  /// Get translated car make name
  /// Returns the original value if translation is not available
  static String getCarMakeTranslation(String carMake, AppLocalizations? l10n) {
    if (l10n == null) return carMake;
    
    switch (carMake) {
      case 'Toyota':
        return l10n.carMakeToyota;
      case 'Hyundai':
        return l10n.carMakeHyundai;
      case 'Nissan':
        return l10n.carMakeNissan;
      case 'Honda':
        return l10n.carMakeHonda;
      case 'Mitsubishi':
        return l10n.carMakeMitsubishi;
      case 'Suzuki':
        return l10n.carMakeSuzuki;
      case 'Mazda':
        return l10n.carMakeMazda;
      case 'Mercedes':
        return l10n.carMakeMercedes;
      case 'BMW':
        return l10n.carMakeBMW;
      case 'Audi':
        return l10n.carMakeAudi;
      case 'Volkswagen':
        return l10n.carMakeVolkswagen;
      case 'Opel':
        return l10n.carMakeOpel;
      case 'Peugeot':
        return l10n.carMakePeugeot;
      case 'Renault':
        return l10n.carMakeRenault;
      case 'Citroën':
        return l10n.carMakeCitroen;
      case 'Kia':
        return l10n.carMakeKia;
      case 'Lexus':
        return l10n.carMakeLexus;
      case 'Subaru':
        return l10n.carMakeSubaru;
      case 'Ford':
        return l10n.carMakeFord;
      case 'Chevrolet':
        return l10n.carMakeChevrolet;
      case 'Dodge':
        return l10n.carMakeDodge;
      case 'Jeep':
        return l10n.carMakeJeep;
      case 'GMC':
        return l10n.carMakeGMC;
      case 'Chery':
        return l10n.carMakeChery;
      case 'Geely':
        return l10n.carMakeGeely;
      case 'BYD':
        return l10n.carMakeBYD;
      case 'Dacia':
        return l10n.carMakeDacia;
      case 'Saipa':
        return l10n.carMakeSaipa;
      case 'Other':
        return l10n.carMakeOther;
      default:
        return carMake; // Return original if no translation
    }
  }

  /// Get translated color name
  /// Returns the original value if translation is not available
  static String getColorTranslation(String colorName, AppLocalizations? l10n) {
    if (l10n == null) return colorName;
    
    switch (colorName) {
      case 'Black':
        return l10n.colorBlack;
      case 'White':
        return l10n.colorWhite;
      case 'Silver':
        return l10n.colorSilver;
      case 'Gray':
        return l10n.colorGray;
      case 'Blue':
        return l10n.colorBlue;
      case 'Red':
        return l10n.colorRed;
      case 'Green':
        return l10n.colorGreen;
      case 'Brown':
        return l10n.colorBrown;
      case 'Beige':
        return l10n.colorBeige;
      case 'Gold':
        return l10n.colorGold;
      case 'Yellow':
        return l10n.colorYellow;
      case 'Orange':
        return l10n.colorOrange;
      case 'Purple':
        return l10n.colorPurple;
      case 'Pink':
        return l10n.colorPink;
      case 'Maroon':
        return l10n.colorMaroon;
      case 'Navy':
        return l10n.colorNavy;
      case 'Burgundy':
        return l10n.colorBurgundy;
      case 'Teal':
        return l10n.colorTeal;
      default:
        return colorName; // Return original if no translation
    }
  }
}

