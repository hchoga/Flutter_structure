import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Application text styles
/// Centralized text style definitions for consistent typography across the app

@immutable
class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.h4,
    required this.h5,
    required this.h6,
    required this.bodyLargeBold,
    required this.bodyLargeMedium,
    required this.bodyLargeRegular,
    required this.bodyMediumBold,
    required this.bodyMediumMedium,
    required this.bodyMediumRegular,
    required this.bodySmallBold,
    required this.bodySmallMedium,
    required this.bodySmallRegular,
    required this.bodyVerySmallRegular,
  });
  // Headings
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle h4;
  final TextStyle h5;
  final TextStyle h6;

  // Body text
  final TextStyle bodyLargeBold;
  final TextStyle bodyLargeMedium;
  final TextStyle bodyLargeRegular;

  final TextStyle bodyMediumBold;
  final TextStyle bodyMediumMedium;
  final TextStyle bodyMediumRegular;

  final TextStyle bodySmallBold;
  final TextStyle bodySmallMedium;
  final TextStyle bodySmallRegular;
  final TextStyle bodyVerySmallRegular;
  static final standard = TextStyleExtension(
    h1: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    h2: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    h3: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    h4: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    h5: TextStyle(
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    h6: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyLargeBold: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyMediumBold: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodySmallBold: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyLargeMedium: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyMediumMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodySmallMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyLargeRegular: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyMediumRegular: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodySmallRegular: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
    bodyVerySmallRegular: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'Almarai',
      height: 1.4,
    ),
  );

  @override
  ThemeExtension<TextStyleExtension> copyWith({
    TextStyle? h1,
    TextStyle? h2,
    TextStyle? h3,
    TextStyle? h4,
    TextStyle? h5,
    TextStyle? h6,
    TextStyle? bodyLargeBold,
    TextStyle? bodyLargeMedium,
    TextStyle? bodyLargeRegular,
    TextStyle? bodyMediumBold,
    TextStyle? bodyMediumMedium,
    TextStyle? bodyMediumRegular,
    TextStyle? bodySmallBold,
    TextStyle? bodySmallMedium,
    TextStyle? bodySmallRegular,
    TextStyle? bodyVerySmallRegular,
  }) {
    return TextStyleExtension(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      h4: h4 ?? this.h4,
      h5: h5 ?? this.h5,
      h6: h6 ?? this.h6,
      bodyLargeBold: bodyLargeBold ?? this.bodyLargeBold,
      bodyLargeMedium: bodyLargeMedium ?? this.bodyLargeMedium,
      bodyLargeRegular: bodyLargeRegular ?? this.bodyLargeRegular,
      bodyMediumBold: bodyMediumBold ?? this.bodyMediumBold,
      bodyMediumMedium: bodyMediumMedium ?? this.bodyMediumMedium,
      bodyMediumRegular: bodyMediumRegular ?? this.bodyMediumRegular,
      bodySmallBold: bodySmallBold ?? this.bodySmallBold,
      bodySmallMedium: bodySmallMedium ?? this.bodySmallMedium,
      bodySmallRegular: bodySmallRegular ?? this.bodySmallRegular,
      bodyVerySmallRegular: bodyVerySmallRegular ?? this.bodyVerySmallRegular,
    );
  }

  @override
  ThemeExtension<TextStyleExtension> lerp(
    ThemeExtension<TextStyleExtension>? other,
    double t,
  ) {
    if (other is! TextStyleExtension) return this;
    return TextStyleExtension(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      h4: TextStyle.lerp(h4, other.h4, t)!,
      h5: TextStyle.lerp(h5, other.h5, t)!,
      h6: TextStyle.lerp(h6, other.h6, t)!,
      bodyLargeBold: TextStyle.lerp(bodyLargeBold, other.bodyLargeBold, t)!,
      bodyLargeMedium: TextStyle.lerp(
        bodyLargeMedium,
        other.bodyLargeMedium,
        t,
      )!,
      bodyLargeRegular: TextStyle.lerp(
        bodyLargeRegular,
        other.bodyLargeRegular,
        t,
      )!,
      bodyMediumBold: TextStyle.lerp(bodyMediumBold, other.bodyMediumBold, t)!,
      bodyMediumMedium: TextStyle.lerp(
        bodyMediumMedium,
        other.bodyMediumMedium,
        t,
      )!,
      bodyMediumRegular: TextStyle.lerp(
        bodyMediumRegular,
        other.bodyMediumRegular,
        t,
      )!,
      bodySmallBold: TextStyle.lerp(bodySmallBold, other.bodySmallBold, t)!,
      bodySmallMedium: TextStyle.lerp(
        bodySmallMedium,
        other.bodySmallMedium,
        t,
      )!,
      bodySmallRegular: TextStyle.lerp(
        bodySmallRegular,
        other.bodySmallRegular,
        t,
      )!,
      bodyVerySmallRegular: TextStyle.lerp(
        bodyVerySmallRegular,
        other.bodyVerySmallRegular,
        t,
      )!,
    );
  }
}
