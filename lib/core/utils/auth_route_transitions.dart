import 'package:flutter/material.dart';

/// Shared transition for Login ↔ Register.
///
/// Uses fade + horizontal slide, 250ms, easeInOutCubic.
/// RTL-aware: slide direction flips so it feels natural in Arabic.
/// Kept separate from business logic and reusable for both routes.
class AuthRouteTransitions {
  AuthRouteTransitions._();

  /// Duration for auth screen transitions (subtle, not flashy).
  static const Duration duration = Duration(milliseconds: 250);

  /// Easing for smooth, calm motion.
  static const Curve curve = Curves.easeInOutCubic;

  /// Horizontal slide offset as fraction of width (subtle: 5%).
  static const double _slideFraction = 0.05;

  /// Builds fade + slide transition for auth routes.
  ///
  /// - [animation]: 0 → 1 for entering route, 1 → 0 for exiting.
  /// - [secondaryAnimation]: opposite phase for the other route.
  /// - RTL: slide direction is flipped so "forward" is left in Arabic.
  static Widget build(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final slideBegin = Offset(isRTL ? -_slideFraction : _slideFraction, 0);
    final slideEnd = Offset.zero;

    final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
    final opacityAnimation = curvedAnimation;
    final slideAnimation = Tween<Offset>(
      begin: slideBegin,
      end: slideEnd,
    ).animate(curvedAnimation);

    return FadeTransition(
      opacity: opacityAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }

  /// Builds a [PageRoute] with the same fade + slide transition.
  /// Use for Navigator.push when you want consistent animation (e.g. map picker).
  static PageRoute<T> buildPageRoute<T>({
    required Widget child,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: build,
    );
  }

  /// نفس الانيميشن (fade + slide) للتبديل بين تبويبات الـ bottom nav.
  /// للاستخدام مع [AnimatedSwitcher.transitionBuilder].
  static Widget buildTabTransition(
    BuildContext context,
    Widget child,
    Animation<double> animation,
  ) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final slideBegin = Offset(isRTL ? -_slideFraction : _slideFraction, 0);
    final slideEnd = Offset.zero;
    final curved = CurvedAnimation(parent: animation, curve: curve);
    final slide = Tween<Offset>(
      begin: slideBegin,
      end: slideEnd,
    ).animate(curved);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(position: slide, child: child),
    );
  }
}
