import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:touch/core/routes/custom_transitions.dart';
import 'package:touch/core/routes/route_names.dart';
import 'package:touch/features/home/presentation/cubit/home_cubit.dart';
import 'package:touch/features/home/presentation/pages/home_page.dart';
import 'package:touch/features/splash/presentation/pages/splash_page.dart';
import 'package:touch/service_locator.dart';

/// GoRouter configuration
/// Following SOLID principles (Single Responsibility Principle)
class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RoutesName.splash.path,
    routes: [
      GoRoute(
        name: RoutesName.splash.name,
        path: RoutesName.splash.path,
        pageBuilder: (context, state) =>
            CustomTransitions.buildPageWithDefaultTransition<SplashPage>(
              context: context,
              state: state,
              child: const SplashPage(),
              transitionType: TransitionType.fade,
            ),
      ),

      GoRoute(
        name: RoutesName.home.name,
        path: RoutesName.home.path,
        pageBuilder: (context, state) =>
            CustomTransitions.buildPageWithDefaultTransition<HomePage>(
              context: context,
              state: state,
              child: BlocProvider<HomeCubit>(
                create: (context) => sl<HomeCubit>(),
                child: const HomePage(),
              ),
              transitionType: TransitionType.fade,
            ),
      ),
      // Add more routes here
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Route not found: ${state.uri}')),
      );
    },
  );
}
