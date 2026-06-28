import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transition with fade animation
class FadeTransitionPage extends CustomTransitionPage<void> {
  FadeTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(
             opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
             child: child,
           );
         },
         transitionDuration: const Duration(milliseconds: 300),
       );
}

/// Custom page transition with slide animation
class SlideTransitionPage extends CustomTransitionPage<void> {
  SlideTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return SlideTransition(
             position: Tween<Offset>(
               begin: const Offset(1, 0),
               end: Offset.zero,
             ).animate(CurveTween(curve: Curves.easeInOut).animate(animation)),
             child: child,
           );
         },
         transitionDuration: const Duration(milliseconds: 300),
       );
}

/// Custom transitions builder for GoRouter
/// Provides different transition types for route navigation
class CustomTransitions {
  static Page<dynamic> buildPageWithDefaultTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    TransitionType transitionType = TransitionType.fade,
  }) {
    switch (transitionType) {
      case TransitionType.fade:
        return FadeTransitionPage(
          key: state.pageKey,
          name: state.name,
          child: child,
        );
      case TransitionType.slide:
        return SlideTransitionPage(
          key: state.pageKey,
          name: state.name,
          child: child,
        );
      case TransitionType.none:
        return MaterialPage<void>(
          key: state.pageKey,
          name: state.name,
          child: child,
        );
    }
  }
}

/// Enum for different transition types
enum TransitionType { fade, slide, none }
