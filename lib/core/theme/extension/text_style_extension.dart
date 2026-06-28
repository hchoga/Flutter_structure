import 'package:flutter/material.dart';
import 'package:touch/core/theme/app_text_styles.dart';

/// Custom wrapper combining Flutter's standard TextTheme with custom styles
class CustomTextTheme {
  final TextTheme _standard;
  final TextStyleExtension _custom;

  CustomTextTheme(this._standard, this._custom);

  // ============ Standard Flutter TextTheme properties ============
  TextStyle? get displayLarge => _standard.displayLarge;
  TextStyle? get displayMedium => _standard.displayMedium;
  TextStyle? get displaySmall => _standard.displaySmall;

  TextStyle? get headlineLarge => _standard.headlineLarge;
  TextStyle? get headlineMedium => _standard.headlineMedium;
  TextStyle? get headlineSmall => _standard.headlineSmall;

  TextStyle? get titleLarge => _standard.titleLarge;
  TextStyle? get titleMedium => _standard.titleMedium;
  TextStyle? get titleSmall => _standard.titleSmall;

  TextStyle? get bodyLarge => _standard.bodyLarge;
  TextStyle? get bodyMedium => _standard.bodyMedium;
  TextStyle? get bodySmall => _standard.bodySmall;

  TextStyle? get labelLarge => _standard.labelLarge;
  TextStyle? get labelMedium => _standard.labelMedium;
  TextStyle? get labelSmall => _standard.labelSmall;

  // ============ Custom heading styles (h1-h6) ============
  /// Heading 1 - 24px, Bold (w700)
  TextStyle get h1 => _custom.h1;

  /// Heading 2 - 24px, Bold (w700)
  TextStyle get h2 => _custom.h2;

  /// Heading 3 - 20px, Bold (w700)
  TextStyle get h3 => _custom.h3;

  /// Heading 4 - 24px, Bold (w700)
  TextStyle get h4 => _custom.h4;

  /// Heading 5 - 20px, Bold (w700)
  TextStyle get h5 => _custom.h5;

  /// Heading 6 - 16px, Bold (w700)
  TextStyle get h6 => _custom.h6;

  // ============ Custom body large (18px) ============
  /// Body Large Bold - 18px, Bold (w700)
  TextStyle get bodyLargeBold => _custom.bodyLargeBold;

  /// Body Large Medium - 18px, Medium (w500)
  TextStyle get bodyLargeMedium => _custom.bodyLargeMedium;

  /// Body Large Regular - 18px, Regular (w400)
  TextStyle get bodyLargeRegular => _custom.bodyLargeRegular;

  // ============ Custom body medium (16px) ============
  /// Body Medium Bold - 16px, Bold (w700)
  TextStyle get bodyMediumBold => _custom.bodyMediumBold;

  /// Body Medium Medium - 16px, Medium (w500)
  TextStyle get bodyMediumMedium => _custom.bodyMediumMedium;

  /// Body Medium Regular - 16px, Regular (w400)
  TextStyle get bodyMediumRegular => _custom.bodyMediumRegular;

  // ============ Custom body small (14px) ============
  /// Body Small Bold - 14px, Bold (w700)
  TextStyle get bodySmallBold => _custom.bodySmallBold;

  /// Body Small Medium - 14px, Medium (w500)
  TextStyle get bodySmallMedium => _custom.bodySmallMedium;

  /// Body Small Regular - 14px, Regular (w400)
  TextStyle get bodySmallRegular => _custom.bodySmallRegular;

  // ============ Custom body very small (12px) ============
  /// Body Very Small Regular - 14px, Regular (w400)
  TextStyle get bodyVerySmallRegular => _custom.bodyVerySmallRegular;
}

extension TextThemeExt on BuildContext {
  /// Access the current theme
  ThemeData get theme => Theme.of(this);

  /// Access the color scheme
  ColorScheme get colors => theme.colorScheme;

  /// Access custom text theme (combines standard Flutter TextTheme with custom styles)
  ///
  /// Usage:
  /// - Standard styles: context.textTheme.headlineLarge, context.textTheme.bodyMedium
  /// - Custom styles: context.textTheme.h1, context.textTheme.bodyMediumBold
  CustomTextTheme get textTheme {
    final customStyles =
        Theme.of(this).extension<TextStyleExtension>() ??
        TextStyleExtension.standard;
    return CustomTextTheme(Theme.of(this).textTheme, customStyles);
  }

  /// Check if current theme is dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if current theme is light mode
  bool get isLightMode => theme.brightness == Brightness.light;
}

extension TextStyleExt on BuildContext {
  /// Access custom text styles directly
  ///
  /// Usage: context.textStyles.h1
  TextStyleExtension get textStyles {
    return Theme.of(this).extension<TextStyleExtension>() ??
        TextStyleExtension.standard;
  }
}
