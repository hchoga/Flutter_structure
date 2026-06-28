import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:touch/core/localization/localization_service.dart';
import 'package:touch/core/routes/app_routes.dart';
import 'package:touch/core/theme/app_theme.dart';
import 'package:touch/core/utils/show_toast.dart';
import 'package:touch/core/widgets/connectivity_overlay.dart';
import 'package:touch/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Setup Service Locator (Dependency Injection)
  setupServiceLocator();

  // Wait for async dependencies to be initialized
  await sl.allReady();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationService.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: LocalizationService.fallbackLocale,
      startLocale: LocalizationService.defaultLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ShowToast.init(context);
    return MaterialApp.router(
      title: 'Touch',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.router,
      builder: _buildAppWithWrapper,
    );
  }

  Widget _buildAppWithWrapper(BuildContext context, Widget? child) {
    // Initialize EasyLoading wrapper
    final _ = EasyLoadingConfig.configureWithScreenUtil();

    var newChild = EasyLoading.init()(context, child);

    // Wrap with connectivity overlay only in release mode
    if (!kDebugMode) {
      newChild = ConnectivityOverlay(child: newChild);
    }
    // Global error widget builder

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: newChild,
    );
  }
}

class EasyLoadingConfig {
  static bool _isConfigured = false;

  static void configureWithScreenUtil() {
    if (_isConfigured) return;
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..textColor = Colors.blue
      ..indicatorColor = Colors.yellow
      ..maskColor = const Color.fromRGBO(0, 0, 0, 0.3)
      ..progressColor = Colors.cyanAccent
      ..userInteractions = false
      ..dismissOnTap = false
      ..fontSize = 12
      ..contentPadding =
          const EdgeInsets.all(10) // Now safe to use
      ..animationStyle = EasyLoadingAnimationStyle.opacity
      ..maskType = EasyLoadingMaskType.custom;
    _isConfigured = true;
  }

  void hideLoading() {
    EasyLoading.dismiss();
  }

  void showLoading(String text) {
    EasyLoading.show(status: text);
  }

  // static void updateThemeColors({
  //   required Color primaryColor,
  //   Color? backgroundColor,
  //   Color? textColor,
  // }) {
  //   EasyLoading.instance
  //     ..textColor = textColor ?? primaryColor
  //     ..backgroundColor = backgroundColor ?? Colors.white;
  // }
}
