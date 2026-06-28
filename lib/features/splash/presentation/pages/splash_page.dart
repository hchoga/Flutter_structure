import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/constants/app_assets.dart';
import 'package:touch/core/routes/route_names.dart';

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
        context.go(RoutesName.login.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD9E3E5), // top left
              Color(0xFFB8CBCD), // top right darker effect
              Color(0xFF7FA7AA), // middle
              Color(0xFF005F63), // bottom
            ],
            stops: [0.0, 0.25, 0.65, 1.0],
          ),
        ),
        child: Center(
          child: Image.asset(AppAssets.splashLogo),

          //  SvgPicture.asset(
          //   AppAssets.splashLogo,
          //   // colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          //   height: 120,
          //   width: 120,
          // ),
        ),
      ),
    );
  }
}
