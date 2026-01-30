import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// امتداد للتنقّل مع مسح الستاك بالكامل.
///
/// مع GoRouter لا يوجد onGenerateRoute، فـ [Navigator.pushNamedAndRemoveUntil]
/// لا يعمل. نستخدم [context.go] الذي يحقق نفس السلوك: ينتقل للصفحة ويمسح الستاك.
extension NavigationClearStack on BuildContext {
  /// ينتقل إلى [location] ويمسح كل الصفحات من الستاك.
  /// [extra] اختياري (مثلاً بيانات لصفحة pre-payment).
  void goAndClearStack(String location, {Object? extra}) {
    go(location, extra: extra);
  }
}
