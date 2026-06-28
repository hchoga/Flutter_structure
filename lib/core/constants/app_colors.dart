import 'dart:ui';

import 'package:flutter/material.dart' as mt;

/// Application color palette from Figma design system
/// All colors are sourced from the HR-App Figma design
abstract final class AppColors {
  // Primary colors
  static const Color primaryMain = Color(0xFF085055);
  static const Color primaryLight = Color(0xFFE3EDEE);
  static const Color primaryDark = Color(0xFF16232B);

  // Dark colors
  static const Color darkD900 = Color(0xFF212427);
  static const Color darkD1 = Color(0xFF1A1919);
  static const Color darkD2 = Color(0xFFDFDFDF);
  static const Color darkD3 = Color(0xFF808080);
  static const Color darkD4 = Color(0xFFEEEEEE);
  static const Color darkD5 = Color(0xFFFAFAFA);

  // Neutral colors
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);

  // Semantic colors
  static const Color error = Color(0xFFFE6241);
  static const Color errorFil = Color(0xFFFFBDCD5);
  static const Color errorFilLight = Color(0xFFFF9EBE9);
  // Legacy mappings for existing code
  static const Color primary = primaryMain;
  static const Color secondary = primaryLight;

  //border colors
  static Color borderColor = mt.Colors.grey.withOpacity(.2);

  // notification title
  static Color orangeColorFil = Color(0xFFEFBDAC);
  static Color orangeColor = Color(0xFFD85B2F);

  //icon colors
  static Color lightGreen = Color(0xFF71C36C);
  static Color greenFil = Color(0xFFE5F5E3);
  static Color orangeLight = Color(0xFFFD9630);
  static Color lightBlue = Color(0xFF14C8D4);
  static Color yellowFil = Color(0xFFF9F5E8);
  static Color lightBlueFil = Color(0xFFE8FBFC);
  static Color brownColor = Color(0xFF532110);
}
