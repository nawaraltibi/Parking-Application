import 'package:flutter/foundation.dart';

/// إشعار عالمي لطلب تحديث قائمة الحجوزات.
///
/// يُستدعى عند الانتقال لتبويب الحجوزات من الـ bottom nav حتى تُستدعى الـ APIs من جديد.
class BookingsListRefreshNotifier extends ChangeNotifier {
  void requestRefresh() {
    notifyListeners();
  }
}
