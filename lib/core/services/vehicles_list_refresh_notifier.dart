import 'package:flutter/foundation.dart';

/// إشعار عالمي لطلب تحديث قائمة المركبات.
///
/// يُستدعى بعد إضافة/تحديث مركبة ناجح حتى تعيد صفحة القائمة استدعاء الـ API
/// وتعرض آخر مركبة، حتى مع استخدام [context.go] الذي لا يعيد بناء الصفحة.
class VehiclesListRefreshNotifier extends ChangeNotifier {
  /// طلب تحديث قائمة المركبات (يستمع له [VehiclesScreen] ويطلق [GetVehiclesRequested]).
  void requestRefresh() {
    notifyListeners();
  }
}
