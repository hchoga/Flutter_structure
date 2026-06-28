import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Localization service for managing app languages
/// Following SOLID principles (Interface Segregation Principle)
class LocalizationService {
  // static const String _enPath = 'assets/translations/en.json';
  // static const String _arPath = 'assets/translations/ar.json';

  static const List<Locale> supportedLocales = [Locale('ar'), Locale('en')];

  static const Locale fallbackLocale = Locale('ar');

  static const Locale defaultLocale = Locale('ar');

  static Future<void> init(BuildContext context) async {
    await EasyLocalization.ensureInitialized();
  }

  static String translate(String key) {
    return key.tr();
  }

  static Locale getCurrentLocale(BuildContext context) {
    return EasyLocalization.of(context)?.locale ?? fallbackLocale;
  }

  static void changeLocale(BuildContext context, Locale locale) {
    EasyLocalization.of(context)?.setLocale(locale);
  }
}
