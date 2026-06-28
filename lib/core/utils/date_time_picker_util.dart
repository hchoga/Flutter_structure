import 'package:flutter/material.dart';

/// Utility class for date and time picker operations
class DateTimePickerUtil {
  /// Shows a date picker with optional time picker.
  ///
  /// [context]     - BuildContext for showing dialogs
  /// [initialDate] - Initial date to display (e.g. the existing request date)
  /// [firstDate]   - Earliest selectable date
  /// [lastDate]    - Latest selectable date
  /// [useTimePicker] - Whether to show time picker after date picker (default: true)
  ///
  /// Returns the selected DateTime, or null if cancelled.
  static Future<DateTime?> selectDateTime({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    bool useTimePicker = true,
  }) async {
    // Guard: if initialDate is before firstDate (e.g. editing an old request),
    // clamp firstDate down so the picker doesn't crash.
    final safeFirstDate =
        firstDate.isAfter(initialDate) ? initialDate : firstDate;

    // Guard: ensure lastDate is never before initialDate either.
    final safeLastDate =
        lastDate.isBefore(initialDate) ? initialDate : lastDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: safeFirstDate,
      lastDate: safeLastDate,
    );

    if (pickedDate == null) return null;
    if (!context.mounted) return null;

    // If time picker is disabled, return date at midnight
    if (!useTimePicker) {
      return DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
    }

    // Show time picker
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }
}
