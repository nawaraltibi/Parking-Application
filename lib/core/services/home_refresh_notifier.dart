import 'package:flutter/foundation.dart';

/// إشعار عالمي لطلب تحديث صفحة الهوم.
///
/// يُستدعى بعد نجاح الدفع حتى تعيد صفحة الهوم استدعاء الـ APIs (مثلاً الحجوزات النشطة)
/// عند الانتقال لها بـ [context.go].
class HomeRefreshNotifier extends ChangeNotifier {
  /// طلب تحديث صفحة الهوم (يستمع له [UserHomePage] ويطلق [LoadActiveBookings]).
  void requestRefresh() {
    notifyListeners();
  }
}
