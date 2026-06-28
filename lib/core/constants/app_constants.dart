/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'Touch';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Cache Constants
  static const int cacheExpirationTime = 3600; // seconds

  // Localization Constants
  static const String fallbackLocale = 'en';
  static const List<String> supportedLocales = ['en', 'ar'];
}
