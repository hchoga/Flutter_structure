import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'app_text_styles.dart';

/// Application theme configuration
/// Following SOLID principles (Single Responsibility Principle)
class AppTheme {
  static const Color primaryColor = AppColors.primaryMain;
  static const Color primaryLightColor = AppColors.primaryLight;
  static const Color primaryDarkColor = AppColors.primaryDark;
  static const Color secondaryColor = AppColors.primaryLight;
  static const Color errorColor = AppColors.error;
  // Literal light-theme values (AppColors.background / neutral100 are now
  // brightness-aware getters, so they can't be used in a const context here).
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: surfaceColor,
      ),
      extensions: <ThemeExtension<dynamic>>[TextStyleExtension.standard],
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: TextTheme(
        // Headings
        headlineLarge: TextStyleExtension.standard.h1,
        headlineMedium: TextStyleExtension.standard.h2,
        headlineSmall: TextStyleExtension.standard.h3,
        // Titles
        titleLarge: TextStyleExtension.standard.h4,
        titleMedium: TextStyleExtension.standard.h5,
        titleSmall: TextStyleExtension.standard.h6,
        // Body text (default)
        bodyLarge: TextStyleExtension.standard.bodyLargeRegular,
        bodyMedium: TextStyleExtension.standard.bodyMediumRegular,
        bodySmall: TextStyleExtension.standard.bodySmallRegular,
        // Labels
        labelLarge: TextStyleExtension.standard.bodyLargeBold,
        labelMedium: TextStyleExtension.standard.bodyMediumBold,
        labelSmall: TextStyleExtension.standard.bodySmallBold,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyleExtension.standard.bodyLargeBold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDarkColor,
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: ColorScheme.dark(
        primary: primaryDarkColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: const Color(0xFF1E1E1E),
      ),
      extensions: <ThemeExtension<dynamic>>[TextStyleExtension.standard],
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDarkColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.4,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        // Headings
        headlineLarge: TextStyleExtension.standard.h1,
        headlineMedium: TextStyleExtension.standard.h2,
        headlineSmall: TextStyleExtension.standard.h3,
        // Titles
        titleLarge: TextStyleExtension.standard.h4,
        titleMedium: TextStyleExtension.standard.h5,
        titleSmall: TextStyleExtension.standard.h6,
        // Body text (default)
        bodyLarge: TextStyleExtension.standard.bodyLargeRegular,
        bodyMedium: TextStyleExtension.standard.bodyMediumRegular,
        bodySmall: TextStyleExtension.standard.bodySmallRegular,
        // Labels
        labelLarge: TextStyleExtension.standard.bodyLargeBold,
        labelMedium: TextStyleExtension.standard.bodyMediumBold,
        labelSmall: TextStyleExtension.standard.bodySmallBold,
      ),
      // Match the light theme's button text style so toggling themes doesn't
      // try to interpolate TextStyles with different `inherit` values.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: TextStyleExtension.standard.bodyLargeBold,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
