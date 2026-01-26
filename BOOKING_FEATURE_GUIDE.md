# 📱 Booking Feature - Complete Integration Guide

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [API Endpoints](#api-endpoints)
4. [Setup Instructions](#setup-instructions)
5. [Usage Examples](#usage-examples)
6. [State Management](#state-management)
7. [Error Handling](#error-handling)
8. [Localization](#localization)
9. [Testing Guide](#testing-guide)
10. [Best Practices](#best-practices)

---

## 🎯 Overview

The Booking feature provides a complete, production-ready implementation for managing parking bookings in your Flutter application. It follows clean architecture principles and integrates seamlessly with your existing codebase.

### Key Features
- ✅ Create parking bookings
- ✅ Cancel existing bookings
- ✅ Extend booking duration
- ✅ Process payments (success/failure)
- ✅ View active and finished bookings
- ✅ Get booking details
- ✅ Check remaining time
- ✅ View payment history
- ✅ Download booking invoices (PDF)
- ✅ Comprehensive error handling
- ✅ Full localization support (English & Arabic)

---

## 🏗️ Architecture

### Folder Structure
```
lib/features/booking/
├── models/                          # Data models
│   ├── booking_model.dart          # Core booking model with nested models
│   ├── create_booking_request.dart
│   ├── create_booking_response.dart
│   ├── extend_booking_request.dart
│   ├── extend_booking_response.dart
│   ├── cancel_booking_response.dart
│   ├── payment_request.dart
│   ├── payment_response.dart
│   ├── bookings_list_response.dart
│   ├── booking_details_response.dart
│   ├── remaining_time_response.dart
│   └── payments_list_response.dart
├── repository/                      # API layer
│   └── booking_repository.dart     # All API calls
├── cubit/                          # State management
│   ├── booking_cubit.dart
│   └── booking_state.dart
└── booking.dart                     # Barrel file for easy imports
```

### Architecture Pattern
- **Models**: Immutable data classes with `fromJson`/`toJson` and safe parsing
- **Repository**: Static methods for API calls, using `APIRequest` and `DioProvider`
- **Cubit**: BLoC pattern for state management with `Equatable` states
- **Localization**: ARB files for English and Arabic

---

## 🌐 API Endpoints

### 1. Create Booking
```dart
POST /api/booking/park
Body: { lot_id, vehicle_id, hours }
Creates a booking with 'pending' status. Payment required to activate.
```

### 2. Cancel Booking
```dart
POST /api/booking/{bookingId}/cancel
Changes booking status to 'inactive'.
```

### 3. Extend Booking
```dart
POST /api/booking/extendbooking/{bookingId}
Body: { extra_hours }
Adds hours to pending_extra_hours. Payment required to apply.
```

### 4. Process Payment Success
```dart
POST /api/booking/paymentsuccess/{bookingId}
Body: { amount, payment_method, transaction_id? }
Activates pending booking or applies extension.
```

### 5. Process Payment Failure
```dart
POST /api/booking/paymentfailed/{bookingId}
Body: { amount, payment_method, transaction_id? }
Records failed payment attempt.
```

### 6. Get Active Bookings
```dart
GET /api/booking/active
Returns all active or pending bookings not yet expired.
```

### 7. Get Finished Bookings
```dart
GET /api/booking/finished
Returns last 15 finished bookings (inactive or expired).
```

### 8. Get Booking Details
```dart
GET /api/booking/getdetails/{bookingId}
Returns detailed information about a specific booking.
```

### 9. Get Remaining Time
```dart
GET /api/booking/remainingtime/{bookingId}
Returns remaining time for an active booking.
```

### 10. Get Payment History
```dart
GET /api/booking/allpayments
Returns last 5 payment records.
```

### 11. Download Booking PDF
```dart
GET /api/booking/printbookingPdf/{bookingId}
Returns booking invoice as PDF file.
```

---

## 🚀 Setup Instructions

### Step 1: Register Cubit with Service Locator

Add to `lib/core/injection/service_locator.dart`:

```dart
import 'package:get_it/get_it.dart';
import '../../features/booking/booking.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // ... existing registrations ...

  // Booking Feature
  getIt.registerFactory<BookingCubit>(() => BookingCubit());
}
```

### Step 2: Generate Localization Files

Run this command to generate localization classes:

```bash
flutter gen-l10n
```

This will generate:
- `lib/l10n/app_localizations.dart`
- `lib/l10n/app_localizations_en.dart`
- `lib/l10n/app_localizations_ar.dart`

### Step 3: Provide Cubit to Widget Tree

In your main app or feature screen:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/booking/booking.dart';
import 'package:your_app/core/injection/service_locator.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ... existing providers ...
        BlocProvider<BookingCubit>(
          create: (context) => getIt<BookingCubit>(),
        ),
      ],
      child: MaterialApp(
        // ... app configuration ...
      ),
    );
  }
}
```

---

## 💻 Usage Examples

### Example 1: Create a Booking

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/booking/booking.dart';

class CreateBookingScreen extends StatelessWidget {
  final int selectedLotId = 1;
  final int selectedVehicleId = 2;
  final int hours = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Booking')),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is CreateBookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Booking created! ID: ${state.response.data?.bookingId}'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to payment screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(
                  bookingId: state.response.data!.bookingId,
                  amount: state.response.data!.totalAmount,
                ),
              ),
            );
          } else if (state is CreateBookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CreateBookingLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<BookingCubit>().createBooking(
                      lotId: selectedLotId,
                      vehicleId: selectedVehicleId,
                      hours: hours,
                    );
              },
              child: Text('Create Booking'),
            ),
          );
        },
      ),
    );
  }
}
```

### Example 2: View Active Bookings

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/booking/booking.dart';

class ActiveBookingsScreen extends StatefulWidget {
  @override
  _ActiveBookingsScreenState createState() => _ActiveBookingsScreenState();
}

class _ActiveBookingsScreenState extends State<ActiveBookingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load active bookings on screen init
    context.read<BookingCubit>().getActiveBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Active Bookings')),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is GetActiveBookingsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetActiveBookingsSuccess) {
            if (state.isEmpty) {
              return Center(child: Text('No active bookings'));
            }

            return ListView.builder(
              itemCount: state.response.data!.length,
              itemBuilder: (context, index) {
                final booking = state.response.data![index];
                return ListTile(
                  leading: Icon(
                    booking.isPending ? Icons.pending : Icons.check_circle,
                    color: booking.isPending ? Colors.orange : Colors.green,
                  ),
                  title: Text('Booking #${booking.bookingId}'),
                  subtitle: Text(
                    '${booking.parkingLot?.lotName ?? "Unknown"}\n'
                    'Status: ${booking.status}',
                  ),
                  trailing: Text('\$${booking.totalAmount.toStringAsFixed(2)}'),
                  onTap: () {
                    // Navigate to booking details
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingDetailsScreen(
                          bookingId: booking.bookingId,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is GetActiveBookingsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<BookingCubit>().getActiveBookings();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
```

### Example 3: Cancel Booking with Confirmation

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/booking/booking.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CancelBookingButton extends StatelessWidget {
  final int bookingId;

  const CancelBookingButton({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is CancelBookingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.bookingCancelledSuccess),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Go back to previous screen
        } else if (state is CancelBookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CancelBookingLoading &&
            state.bookingId == bookingId;

        return ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.cancelBooking),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.confirmCancelBooking),
                          SizedBox(height: 8),
                          Text(
                            l10n.cancelBookingWarning,
                            style: TextStyle(
                              color: Colors.red,
                              fontStyle: FontStyle.italic,
                            ),
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

                  if (confirmed == true) {
                    context.read<BookingCubit>().cancelBooking(
                          bookingId: bookingId,
                        );
                  }
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(l10n.cancelBooking),
        );
      },
    );
  }
}
```

### Example 4: Process Payment

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/booking/booking.dart';

class PaymentScreen extends StatelessWidget {
  final int bookingId;
  final double amount;

  const PaymentScreen({
    required this.bookingId,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is ProcessPaymentSuccess) {
            if (state.wasSuccessfulPayment) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment successful! Booking activated.'),
                  backgroundColor: Colors.green,
                ),
              );
              // Navigate to booking details or home
              Navigator.popUntil(context, (route) => route.isFirst);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment failed. Please try again.'),
                  backgroundColor: Colors.orange,
                ),
              );
            }
          } else if (state is ProcessPaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProcessPaymentLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Amount to Pay',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '\$${amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 32, color: Colors.green),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Simulate payment gateway success
                          context.read<BookingCubit>().processPaymentSuccess(
                                bookingId: bookingId,
                                amount: amount,
                                paymentMethod: 'online',
                                transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Pay Now', style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          // Simulate payment failure
                          context.read<BookingCubit>().processPaymentFailure(
                                bookingId: bookingId,
                                amount: amount,
                                paymentMethod: 'online',
                              );
                        },
                  child: Text('Simulate Payment Failure'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Example 5: Download Booking PDF

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:your_app/features/booking/booking.dart';

class DownloadInvoiceButton extends StatelessWidget {
  final int bookingId;

  const DownloadInvoiceButton({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is DownloadBookingPdfSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invoice downloaded: ${state.filePath}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is DownloadBookingPdfError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is DownloadBookingPdfLoading && 
            state.bookingId == bookingId) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(value: state.progress),
              SizedBox(height: 8),
              Text('${(state.progress * 100).toInt()}%'),
            ],
          );
        }

        return ElevatedButton.icon(
          onPressed: () async {
            // Get app's documents directory
            final dir = await getApplicationDocumentsDirectory();
            final savePath = '${dir.path}/booking_$bookingId.pdf';

            context.read<BookingCubit>().downloadBookingPdf(
                  bookingId: bookingId,
                  savePath: savePath,
                );
          },
          icon: Icon(Icons.download),
          label: Text('Download Invoice'),
        );
      },
    );
  }
}
```

---

## 🎛️ State Management

### All Available States

#### Create Booking
- `CreateBookingLoading` - Loading state
- `CreateBookingSuccess` - Success with `CreateBookingResponse`
- `CreateBookingError` - Error with message and validation errors

#### Cancel Booking
- `CancelBookingLoading(bookingId)` - Loading state with booking ID
- `CancelBookingSuccess` - Success with `CancelBookingResponse`
- `CancelBookingError` - Error with message

#### Extend Booking
- `ExtendBookingLoading(bookingId)` - Loading state
- `ExtendBookingSuccess` - Success with `ExtendBookingResponse`
- `ExtendBookingError` - Error with message

#### Payment Processing
- `ProcessPaymentLoading(bookingId, isSuccess)` - Loading state
- `ProcessPaymentSuccess(response, wasSuccessfulPayment)` - Success
- `ProcessPaymentError` - Error with message

#### Get Active Bookings
- `GetActiveBookingsLoading` - Loading state
- `GetActiveBookingsSuccess` - Success with list (has `isEmpty` helper)
- `GetActiveBookingsError` - Error with message

#### Get Finished Bookings
- `GetFinishedBookingsLoading` - Loading state
- `GetFinishedBookingsSuccess` - Success with list (has `isEmpty` helper)
- `GetFinishedBookingsError` - Error with message

#### Get Booking Details
- `GetBookingDetailsLoading(bookingId)` - Loading state
- `GetBookingDetailsSuccess` - Success with `BookingDetailsResponse`
- `GetBookingDetailsError` - Error with message

#### Get Remaining Time
- `GetRemainingTimeLoading(bookingId)` - Loading state
- `GetRemainingTimeSuccess` - Success with `RemainingTimeResponse`
- `GetRemainingTimeError` - Error with message

#### Get Payment History
- `GetPaymentHistoryLoading` - Loading state
- `GetPaymentHistorySuccess` - Success with list (has `isEmpty` helper)
- `GetPaymentHistoryError` - Error with message

#### Download PDF
- `DownloadBookingPdfLoading(bookingId, progress)` - Loading with progress (0.0 to 1.0)
- `DownloadBookingPdfSuccess(bookingId, filePath)` - Success with file path
- `DownloadBookingPdfError` - Error with message

---

## 🚨 Error Handling

### HTTP Status Codes

| Code | Meaning | Common Causes |
|------|---------|---------------|
| 401 | Unauthenticated | Missing or invalid token |
| 403 | Forbidden | Vehicle not owned, lot unavailable, lot full |
| 404 | Not Found | Booking doesn't exist or doesn't belong to user |
| 409 | Conflict | Already cancelled, duplicate booking |
| 422 | Validation Error | Invalid input, missing required fields |
| 500 | Server Error | Backend error, database issue |

### Error State Structure

All error states include:
```dart
{
  String message;              // User-friendly error message
  int? statusCode;            // HTTP status code
  String? errorCode;          // Machine-readable error code
  Map<String, List<String>>? validationErrors;  // Field-specific validation errors
}
```

### Handling Validation Errors

```dart
if (state is CreateBookingError && state.validationErrors != null) {
  state.validationErrors!.forEach((field, errors) {
    print('$field: ${errors.join(", ")}');
  });
  
  // Example: Display errors for specific field
  if (state.validationErrors!.containsKey('hours')) {
    // Show error for hours field
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Invalid Hours'),
        content: Text(state.validationErrors!['hours']!.first),
      ),
    );
  }
}
```

---

## 🌍 Localization

### Using Localized Strings

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// In widget
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.bookingTitle);           // "Booking" (EN) | "الحجز" (AR)
  return Text(l10n.activeBookings);         // "Active Bookings" (EN) | "الحجوزات النشطة" (AR)
  return Text(l10n.noActiveBookings);       // "No active bookings" (EN) | "لا توجد حجوزات نشطة" (AR)
}
```

### Available Localization Keys

All localization keys are prefixed with `booking` for the feature:
- `bookingTitle`, `createBooking`, `cancelBooking`, `extendBooking`
- `activeBookings`, `finishedBookings`, `bookingDetails`
- `statusActive`, `statusPending`, `statusInactive`
- `paymentMethod`, `paymentMethodCash`, `paymentMethodCredit`, `paymentMethodOnline`
- `bookingNotFound`, `parkingLotFull`, `vehicleNotOwned`
- And many more (see `app_en.arb` and `app_ar.arb`)

---

## 🧪 Testing Guide

### Unit Testing Repository

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:your_app/features/booking/booking.dart';

void main() {
  group('BookingRepository', () {
    test('createBooking returns CreateBookingResponse on success', () async {
      // Test implementation
    });

    test('createBooking throws AppException on 422 validation error', () async {
      // Test implementation
    });
  });
}
```

### Widget Testing with Cubit

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/features/booking/booking.dart';

void main() {
  group('ActiveBookingsScreen', () {
    testWidgets('shows loading indicator when loading', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider(
            create: (_) => BookingCubit()..getActiveBookings(),
            child: ActiveBookingsScreen(),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

---

## ✅ Best Practices

### 1. Always Reset Cubit State When Leaving Screen
```dart
@override
void dispose() {
  context.read<BookingCubit>().reset();
  super.dispose();
}
```

### 2. Handle All State Types
```dart
BlocBuilder<BookingCubit, BookingState>(
  builder: (context, state) {
    if (state is CreateBookingLoading) return LoadingWidget();
    if (state is CreateBookingSuccess) return SuccessWidget();
    if (state is CreateBookingError) return ErrorWidget(error: state.message);
    return InitialWidget(); // Don't forget initial state!
  },
)
```

### 3. Use BlocListener for Side Effects
```dart
BlocListener<BookingCubit, BookingState>(
  listener: (context, state) {
    if (state is CreateBookingSuccess) {
      // Navigation, SnackBars, Dialogs, etc.
      Navigator.push(...);
    }
  },
  child: YourWidget(),
)
```

### 4. Provide Cubit at Appropriate Level
- **Whole app**: If booking is used across multiple features
- **Feature level**: If booking is specific to one feature
- **Screen level**: If cubit state should be isolated per screen

### 5. Always Clean Token Before Sending
The `APIRequest` class automatically handles token retrieval and cleaning, but ensure tokens are stored without extra whitespace.

### 6. Handle Pagination for Large Lists
The current implementation limits results:
- Active bookings: 10 items
- Finished bookings: 15 items
- Payment history: 5 items

If you need more, implement pagination in the repository and cubit.

### 7. Use Proper Payment Method Values
Accepted values: `'cash'`, `'credit'`, `'online'`

### 8. Always Validate User Input
```dart
if (hours < 1) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.invalidHours)),
  );
  return;
}
```

---

## 📚 Additional Resources

- **Backend API Documentation**: `backend/routes/api.php`
- **Postman Collection**: `Parking_App_API_Collection.postman_collection.json`
- **Localization Guide**: Flutter's official l10n documentation

---

## 🎉 Summary

The Booking feature is now **fully integrated and ready for UI implementation**. All business logic, state management, API calls, error handling, and localization are complete and production-ready.

### Next Steps:
1. Create UI screens for booking workflows
2. Integrate payment gateway (if using external service)
3. Add booking notifications (push/local)
4. Implement booking reminders
5. Add analytics tracking for booking events

---

**Happy Coding! 🚀**

