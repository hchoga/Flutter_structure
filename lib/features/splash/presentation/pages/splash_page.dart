import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/routes/route_names.dart';
import 'package:touch/generated/locale_keys.g.dart';

/// Splash page - simple app entry point
/// Auto-navigates to home after 4 seconds
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        context.go(RoutesName.home.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            const Icon(Icons.touch_app, size: 80, color: Colors.blue),
            const SizedBox(height: 24),
            // App Title
            Text(
              LocaleKeys.app_name.tr(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              LocaleKeys.loading.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
