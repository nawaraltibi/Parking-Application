/// Assets class
/// Contains all asset paths used in the application
class Assets {
  Assets._();

  // Images
  static const String imagesLogo = 'assets/images/logo.png';
  static const String imagesLogin = 'assets/images/login.png';
  static const String imagesSignUp = 'assets/images/sign-up.png';
  
  // Car Logos
  static const String carLogoBmw = 'assets/car_logo/bmw.png';
  
  /// Get car logo path based on car make
  /// Returns the asset path for the car logo, or null if logo doesn't exist
  /// Handles special cases like "Citroën" -> "citroen"
  static String? getCarLogoPath(String carMake) {
    if (carMake.isEmpty) return null;
    
    // Normalize car make name to match file naming convention
    // Convert to lowercase and handle special characters
    String normalizedMake = carMake.toLowerCase().trim();
    
    // Handle special character mappings
    normalizedMake = normalizedMake
        .replaceAll('ë', 'e') // Citroën -> citroen
        .replaceAll('é', 'e')
        .replaceAll('è', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('à', 'a')
        .replaceAll('á', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ö', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ü', 'u')
        .replaceAll('ù', 'u')
        .replaceAll('û', 'u')
        .replaceAll('ç', 'c');
    
    return 'assets/car_logo/$normalizedMake.png';
  }
}
