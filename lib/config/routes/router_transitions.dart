import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage<void> buildSlideTransition(
  Widget child,
  GoRouterState state,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;

      final slideIn = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: curve));

      final fadeIn = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));

      final slideOut = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.25, 0.0),
      ).chain(CurveTween(curve: curve));

      final fadeOut = Tween<double>(
        begin: 1.0,
        end: 0.85,
      ).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: secondaryAnimation.drive(slideOut),
        child: FadeTransition(
          opacity: secondaryAnimation.drive(fadeOut),
          child: SlideTransition(
            position: animation.drive(slideIn),
            child: FadeTransition(
              opacity: animation.drive(fadeIn),
              child: child,
            ),
          ),
        ),
      );
    },
  );
}
