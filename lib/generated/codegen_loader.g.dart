// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _ar = {
  "home_title": "الرئيسية",
  "welcome": "مرحبا بك في تاتش",
  "app_name": "تاتش",
  "error": "خطأ",
  "retry": "إعادة محاولة",
  "loading": "جاري التحميل...",
  "no_data": "لا توجد بيانات متاحة",
  "login": {
    "welcome_back": "مرحبا بعودتك",
    "please_sign_in": "من فضلك قم بتسجيل الدخول",
    "language": "العربية",
    "welcome_message": "مرحبا {}",
    "method_phone": "هاتف",
    "method_email": "بريد إلكتروني",
    "method_civil_id": "رقم قومي",
    "hint_phone": "ادخل رقم الهاتف",
    "hint_email": "ادخل البريد الالكتروني",
    "hint_civil_id": "ادخل الرقم القومي",
    "hint_identifier_default": "ادخل الرقم القومي / البريد الالكتروني",
    "hint_password": "أدخل كلمة المرور",
    "forgot_password": "نسيت كلمة المرور؟",
    "sign_in_button": "دخول",
    "divider_or": "او",
    "biometric_face": "بصمة الوجه",
    "biometric_fingerprint": "بصمه اليد",
    "error_phone_required": "يرجى إدخال رقم الهاتف",
    "error_email_required": "يرجى إدخال البريد الإلكتروني",
    "error_civil_id_required": "يرجى إدخال الرقم القومي",
    "error_identifier_required": "يرجى إدخال بيانات صحيحة",
    "error_phone_invalid": "رقم الهاتف غير صحيح",
    "error_email_invalid": "البريد الإلكتروني غير صحيح",
    "error_civil_id_invalid": "الرقم القومي غير صحيح",
    "error_identifier_invalid": "البيانات غير صحيحة",
    "error_password_required": "يرجى إدخال كلمة المرور",
    "error_password_too_short": "كلمة المرور يجب أن تكون 6 أحرف على الأقل",
    "cache_error_save": "فشل في حفظ بيانات المستخدم: {}",
    "cache_error_read": "فشل في استرجاع بيانات المستخدم: {}",
    "cache_error_clear": "فشل في مسح البيانات المؤقتة: {}"
  }
};
static const Map<String,dynamic> _en = {
  "home_title": "Home",
  "welcome": "Welcome to Touch",
  "app_name": "Touch",
  "error": "Error",
  "retry": "Retry",
  "loading": "Loading...",
  "no_data": "No data available",
  "login": {
    "welcome_back": "Welcome Back",
    "please_sign_in": "Please sign in to continue",
    "language": "English",
    "welcome_message": "Welcome {}",
    "method_phone": "Phone",
    "method_email": "Email",
    "method_civil_id": "Civil ID",
    "hint_phone": "Enter phone number",
    "hint_email": "Enter email address",
    "hint_civil_id": "Enter civil ID",
    "hint_identifier_default": "Enter civil ID / email",
    "hint_password": "Enter password",
    "forgot_password": "Forgot Password?",
    "sign_in_button": "Sign In",
    "divider_or": "or",
    "biometric_face": "Face ID",
    "biometric_fingerprint": "Fingerprint",
    "error_phone_required": "Please enter phone number",
    "error_email_required": "Please enter email address",
    "error_civil_id_required": "Please enter civil ID",
    "error_identifier_required": "Please enter valid data",
    "error_phone_invalid": "Invalid phone number",
    "error_email_invalid": "Invalid email address",
    "error_civil_id_invalid": "Invalid civil ID",
    "error_identifier_invalid": "Invalid data",
    "error_password_required": "Please enter password",
    "error_password_too_short": "Password must be at least 6 characters",
    "cache_error_save": "Failed to cache user: {}",
    "cache_error_read": "Failed to retrieve cached user: {}",
    "cache_error_clear": "Failed to clear cache: {}"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": _ar, "en": _en};
}
