import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch/core/services/secure_storage_service.dart';

/// Holds the app's [ThemeMode] (light/dark) and persists the choice so it
/// survives restarts.
class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorageService storage;

  ThemeCubit({required this.storage}) : super(ThemeMode.light);

  static const String _key = 'theme_mode';

  /// Whether dark mode is currently active.
  bool get isDark => state == ThemeMode.dark;

  /// Loads the persisted theme mode (call once on startup).
  Future<void> load() async {
    try {
      final saved = await storage.read(key: _key);
      if (saved == 'dark') {
        emit(ThemeMode.dark);
      } else if (saved == 'light') {
        emit(ThemeMode.light);
      }
    } catch (_) {
      // Ignore — fall back to the default light theme.
    }
  }

  /// Switches between light and dark and persists the new value.
  Future<void> setDark(bool dark) async {
    final mode = dark ? ThemeMode.dark : ThemeMode.light;
    if (mode == state) return;
    emit(mode);
    try {
      await storage.write(key: _key, value: dark ? 'dark' : 'light');
    } catch (_) {
      // Persistence is best-effort.
    }
  }
}
