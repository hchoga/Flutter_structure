import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:touch/generated/locale_keys.g.dart';

class LoginValidation {
  static bool isValidIdentifier(String identifier, String loginMethod) {
    switch (loginMethod) {
      case 'phone':
        // Phone validation: at least 9 digits
        return identifier.replaceAll(RegExp(r'[^\d]'), '').length >= 9;
      case 'email':
        // Email validation
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        );
        return emailRegex.hasMatch(identifier);
      case 'civil_id':
        // Civil ID validation: usually 14 digits for Egypt
        return identifier.replaceAll(RegExp(r'[^\d]'), '').length >= 10;
      default:
        return true;
    }
  }

  static String getIdentifierErrorMessage(String loginMethod) {
    switch (loginMethod) {
      case 'phone':
        return LocaleKeys.login_error_phone_required.tr();
      case 'email':
        return LocaleKeys.login_error_email_required.tr();
      case 'civil_id':
        return LocaleKeys.login_error_civil_id_required.tr();
      default:
        return LocaleKeys.login_error_identifier_required.tr();
    }
  }

  static String getIdentifierFormatErrorMessage(String loginMethod) {
    switch (loginMethod) {
      case 'phone':
        return LocaleKeys.login_error_phone_invalid.tr();
      case 'email':
        return LocaleKeys.login_error_email_invalid.tr();
      case 'civil_id':
        return LocaleKeys.login_error_civil_id_invalid.tr();
      default:
        return LocaleKeys.login_error_identifier_invalid.tr();
    }
  }
}
