import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TimeFormatter {
  static String formatTime(
    String time,
    BuildContext context, {
    bool hideLabel = false,
  }) {
    try {
      final parts = time.split(':');
      if (parts.length < 2) return time;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      final isArabic = context.locale.languageCode == 'ar';

      var period = hour >= 12
          ? (isArabic ? 'م' : 'PM')
          : (isArabic ? 'ص' : 'AM');
      if (hideLabel) {
        period = "";
      }
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;

      String minuteStr = minute.toString().padLeft(2, '0');
      String hourStr = hour12.toString();

      if (isArabic) {
        hourStr = _convertToArabicNumbers(hourStr);
        minuteStr = _convertToArabicNumbers(minuteStr);
      }

      return '$hourStr:$minuteStr $period';
    } catch (_) {
      return time;
    }
  }

  static String _convertToArabicNumbers(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], arabic[i]);
    }

    return input;
  }

  static String formatDateInDays(BuildContext context, String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat(
        'EEEE d MMMM y',
        context.locale.languageCode,
      ).format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

  static String formatDateBasicView(BuildContext context, DateTime? date) {
    if (date == null) return '';
    final String inputDate =
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
    if (context.locale.languageCode == "ar") {
      final String dateConverted = _convertToArabicNumbers(inputDate);
      return dateConverted;
    }
    return inputDate;
  }

  static String? formatDateApiForm(DateTime? d) {
    if (d == null) return null;
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String formatDateAndTime(BuildContext context, DateTime dt) {
    final date =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
    final time = TimeOfDay.fromDateTime(dt).format(context);
    String dateFormatted = '$date  $time';
    if (context.locale.languageCode == "ar") {
      return _convertToArabicNumbers(dateFormatted);
    }
    return dateFormatted;
  }
}
