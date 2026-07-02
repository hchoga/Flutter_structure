import 'dart:ui';

/// Application color palette from the Figma design system.
///
/// Surface / text / border colors are **brightness-aware**: they flip between
/// light and dark variants based on [isDark] (set from the app theme on every
/// theme change). Brand and accent colors stay constant across both themes.
abstract final class AppColors {
  /// Whether the dark palette is active. Set from the active [ThemeMode] in
  /// `main` so every `AppColors` getter resolves to the right variant.
  static bool isDark = false;

  /// Picks [light] or [dark] based on the active brightness.
  static Color _c(Color light, Color dark) => isDark ? dark : light;

  // ── Brand colors (same in both themes) ──────────────────────────────────
  static const Color primaryMain = Color(0xFF085055);
  static const Color primaryLight = Color(0xFFE3EDEE);
  static const Color primaryDark = Color(0xFF16232B);
  static const Color primary = primaryMain;
  static const Color secondary = primaryLight;

  // ── Surfaces / backgrounds (flip with theme) ────────────────────────────
  /// Page background.
  static Color get background => _c(const Color(0xFFF8FAFC), const Color(0xFF121212));

  /// Card / sheet surface (was pure white).
  static Color get neutral100 => _c(const Color(0xFFFFFFFF), const Color(0xFF1E1E1E));

  /// Alias of [neutral100] for code replacing raw `Colors.white` surfaces.
  static Color get surface => neutral100;

  // ── Text / icon greys (flip with theme) ─────────────────────────────────
  /// Strong heading text.
  static Color get darkD900 => _c(const Color(0xFF212427), const Color(0xFFECECEC));
  
  /// Primary text.
  static Color get darkD1 => _c(const Color(0xFF1A1919), const Color(0xFFECECEC));

  /// Light divider / inactive border.
  static Color get darkD2 => _c(const Color(0xFFDFDFDF), const Color(0xFF3A3A3A));

  /// Secondary / hint text and muted icons.
  static Color get darkD3 => _c(const Color(0xFF808080), const Color(0xFF9E9E9E));

  /// Dividers and icon-container backgrounds.
  static Color get darkD4 => _c(const Color(0xFFEEEEEE), const Color(0xFF2A2A2A));

  /// Subtle light surface.
  static Color get darkD5 => _c(const Color(0xFFFAFAFA), const Color(0xFF1E1E1E));

  /// Generic border.
  static Color get borderColor =>
      _c(const Color(0x33808080), const Color(0x33FFFFFF));

  // ── Semantic / accent colors (same in both themes) ──────────────────────
  static const Color error = Color(0xFFFE6241);
  static const Color errorFil = Color(0xFFFBDCD5);
  static const Color errorFilLight = Color(0xFFF9EBE9);

  static const Color orangeColorFil = Color(0xFFEFBDAC);
  static const Color orangeColor = Color(0xFFD85B2F);

  static const Color lightGreen = Color(0xFF71C36C);
  static const Color greenFil = Color(0xFFE5F5E3);
  static const Color whatsappGreen = Color(0xFF25D366);
  static const Color orangeLight = Color(0xFFFD9630);
  static const Color lightBlue = Color(0xFF14C8D4);
  static const Color yellowFil = Color(0xFFF9F5E8);
  static const Color lightBlueFil = Color(0xFFE8FBFC);
  static const Color brownColor = Color(0xFF532110);

  // ── Foreground that must stay light on colored surfaces ─────────────────
  /// Text / icons drawn on top of primary-colored surfaces (always light).
  static const Color onPrimary = Color(0xFFFFFFFF);
}
