# 🚀 Booking Feature - Quick Reference

## 📦 Import Everything
```dart
import 'package:your_app/features/booking/booking.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
```

## 🎯 Quick Setup (3 Steps)

### 1. Register in Service Locator
```dart
// lib/core/injection/service_locator.dart
getIt.registerFactory<BookingCubit>(() => BookingCubit());
```

### 2. Provide in Widget Tree
```dart
BlocProvider<BookingCubit>(
  create: (context) => getIt<BookingCubit>(),
  child: YourScreen(),
)
```

### 3. Generate Localization
```bash
flutter gen-l10n
```

---

## 🔥 Quick Usage Patterns

### Create Booking
```dart
context.read<BookingCubit>().createBooking(
  lotId: 1,
  vehicleId: 2,
  hours: 3,
);
```

### Cancel Booking
```dart
context.read<BookingCubit>().cancelBooking(bookingId: 5);
```

### Extend Booking
```dart
context.read<BookingCubit>().extendBooking(
  bookingId: 5,
  extraHours: 2,
);
```

### Process Payment Success
```dart
context.read<BookingCubit>().processPaymentSuccess(
  bookingId: 5,
  amount: 36.0,
  paymentMethod: 'online',
  transactionId: 'TXN123',
);
```

### Get Active Bookings
```dart
context.read<BookingCubit>().getActiveBookings();
```

### Get Finished Bookings
```dart
context.read<BookingCubit>().getFinishedBookings();
```

### Get Booking Details
```dart
context.read<BookingCubit>().getBookingDetails(bookingId: 5);
```

### Get Remaining Time
```dart
context.read<BookingCubit>().getRemainingTime(bookingId: 5);
```

### Get Payment History
```dart
context.read<BookingCubit>().getPaymentHistory();
```

### Download PDF Invoice
```dart
final dir = await getApplicationDocumentsDirectory();
final savePath = '${dir.path}/booking_$bookingId.pdf';

context.read<BookingCubit>().downloadBookingPdf(
  bookingId: 5,
  savePath: savePath,
);
```

---

## 🎭 State Handling Pattern

### Standard BlocConsumer Pattern
```dart
BlocConsumer<BookingCubit, BookingState>(
  listener: (context, state) {
    // Handle side effects (navigation, snackbars, dialogs)
    if (state is CreateBookingSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success!')),
      );
    } else if (state is CreateBookingError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  builder: (context, state) {
    // Build UI based on state
    if (state is CreateBookingLoading) {
      return CircularProgressIndicator();
    }
    return YourWidget();
  },
)
```

---

## 🚨 Error Handling

### Check HTTP Status Code
```dart
if (state is CreateBookingError) {
  switch (state.statusCode) {
    case 401:
      // Unauthorized - redirect to login
      break;
    case 404:
      // Not found
      break;
    case 422:
      // Validation errors
      final errors = state.validationErrors;
      break;
    case 500:
      // Server error
      break;
  }
}
```

### Handle Validation Errors
```dart
if (state is CreateBookingError && state.validationErrors != null) {
  state.validationErrors!.forEach((field, errors) {
    print('$field: ${errors.join(", ")}');
  });
}
```

---

## 🌍 Localization Snippets

```dart
final l10n = AppLocalizations.of(context)!;

l10n.bookingTitle                 // "Booking" | "الحجز"
l10n.createBooking                // "Create Booking" | "إنشاء حجز"
l10n.cancelBooking                // "Cancel Booking" | "إلغاء الحجز"
l10n.extendBooking                // "Extend Booking" | "تمديد الحجز"
l10n.activeBookings               // "Active Bookings" | "الحجوزات النشطة"
l10n.finishedBookings             // "Finished Bookings" | "الحجوزات المنتهية"
l10n.noActiveBookings             // "No active bookings" | "لا توجد حجوزات نشطة"
l10n.statusActive                 // "Active" | "نشط"
l10n.statusPending                // "Pending Payment" | "بانتظار الدفع"
l10n.statusInactive               // "Cancelled" | "ملغى"
l10n.paymentMethodCash            // "Cash" | "نقداً"
l10n.paymentMethodCredit          // "Credit Card" | "بطاقة ائتمان"
l10n.paymentMethodOnline          // "Online Payment" | "دفع إلكتروني"
```

---

## 📊 Model Quick Access

### Booking Model Properties
```dart
booking.bookingId
booking.startTime
booking.endTime
booking.status            // 'active', 'pending', 'inactive'
booking.totalAmount
booking.parkingLot        // ParkingLotInfo?
booking.vehicle           // VehicleInfo?
booking.payment           // PaymentInfo?

// Helper methods
booking.isActive
booking.isPending
booking.isInactive
booking.hasPendingExtension
```

### Payment Model Properties
```dart
payment.paymentId
payment.amount
payment.paymentMethod     // 'cash', 'credit', 'online'
payment.status
payment.transactionId
payment.booking           // BookingModel?

// Helper methods
payment.isSuccess
payment.isFailed
```

### Response Helpers
```dart
// BookingsListResponse
response.hasBookings
response.bookingsCount
response.data             // List<BookingModel>?

// PaymentsListResponse
response.hasPayments
response.paymentsCount
response.data             // List<PaymentModel>?

// RemainingTimeResponse
response.hasWarning
response.hasExpired
response.remainingTime    // "HH:MM:SS"
response.remainingSeconds
```

---

## 🎨 Common UI Patterns

### Loading Button
```dart
ElevatedButton(
  onPressed: state is CreateBookingLoading ? null : () {
    context.read<BookingCubit>().createBooking(...);
  },
  child: state is CreateBookingLoading
      ? CircularProgressIndicator()
      : Text('Create Booking'),
)
```

### Empty State
```dart
if (state is GetActiveBookingsSuccess && state.isEmpty) {
  return Center(
    child: Text(l10n.noActiveBookings),
  );
}
```

### Status Badge
```dart
Widget _buildStatusBadge(BookingModel booking) {
  Color color;
  String text;

  if (booking.isPending) {
    color = Colors.orange;
    text = l10n.statusPending;
  } else if (booking.isActive) {
    color = Colors.green;
    text = l10n.statusActive;
  } else {
    color = Colors.grey;
    text = l10n.statusInactive;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    ),
  );
}
```

### Confirmation Dialog
```dart
Future<bool?> showCancelConfirmation(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.cancelBooking),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.confirmCancelBooking),
          SizedBox(height: 8),
          Text(
            l10n.cancelBookingWarning,
            style: TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text('Yes', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
```

---

## 🔑 Payment Methods

Valid payment method values:
- `'cash'` - Cash payment
- `'credit'` - Credit card
- `'online'` - Online/digital payment

---

## 📱 Backend API Endpoints

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/api/booking/park` | ✅ | Create booking |
| POST | `/api/booking/{id}/cancel` | ✅ | Cancel booking |
| POST | `/api/booking/extendbooking/{id}` | ✅ | Extend booking |
| POST | `/api/booking/paymentsuccess/{id}` | ✅ | Process payment success |
| POST | `/api/booking/paymentfailed/{id}` | ✅ | Process payment failure |
| GET | `/api/booking/active` | ✅ | Get active bookings |
| GET | `/api/booking/finished` | ✅ | Get finished bookings |
| GET | `/api/booking/getdetails/{id}` | ✅ | Get booking details |
| GET | `/api/booking/remainingtime/{id}` | ✅ | Get remaining time |
| GET | `/api/booking/allpayments` | ✅ | Get payment history |
| GET | `/api/booking/printbookingPdf/{id}` | ✅ | Download PDF invoice |

---

## ⚡ Pro Tips

1. **Always reset cubit** when leaving screen:
   ```dart
   @override
   void dispose() {
     context.read<BookingCubit>().reset();
     super.dispose();
   }
   ```

2. **Use BlocListener for side effects**, BlocBuilder for UI:
   ```dart
   BlocConsumer<BookingCubit, BookingState>(
     listener: (context, state) { /* Navigation, SnackBars */ },
     builder: (context, state) { /* UI */ },
   )
   ```

3. **Handle all states** including `BookingInitial`

4. **Check isEmpty helpers** on list responses:
   ```dart
   if (state is GetActiveBookingsSuccess && state.isEmpty) {
     // Show empty state
   }
   ```

5. **Token is automatically handled** by `APIRequest` class

6. **Validation errors** are available in `CreateBookingError.validationErrors`

---

## 🐛 Common Issues

### Issue: 401 Unauthenticated
**Solution**: Token expired or missing. Redirect to login.

### Issue: 404 Not Found
**Solution**: Booking doesn't belong to user or doesn't exist.

### Issue: 422 Validation Error
**Solution**: Check `state.validationErrors` for field-specific errors.

### Issue: Booking status is 'pending' but trying to extend
**Solution**: Only 'active' (paid) bookings can be extended. User must complete payment first.

---

## 📚 Full Documentation

For complete details, examples, and architecture explanation, see:
- `BOOKING_FEATURE_GUIDE.md` - Comprehensive guide with examples
- `lib/features/booking/` - Source code with inline documentation

---

**Last Updated**: 2026-01-24

