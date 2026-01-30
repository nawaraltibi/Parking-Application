import 'package:flutter/foundation.dart';

/// إشعار عالمي لطلب تحديث قائمة المواقف.
///
/// يُستدعى بعد إضافة/تحديث موقف ناجح حتى تعيد صفحة القائمة استدعاء الـ API
/// وتعرض آخر موقف، حتى مع استخدام [context.go] الذي لا يعيد بناء الصفحة.
class ParkingListRefreshNotifier extends ChangeNotifier {
  /// طلب تحديث قائمة المواقف (يستمع له [ParkingListScreen] ويطلق [RefreshParkings]).
  void requestRefresh() {
    notifyListeners();
  }
}
