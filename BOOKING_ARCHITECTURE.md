# 🏗️ Booking Feature - Architecture Overview

## 📐 Architecture Pattern

The Booking feature follows **Clean Architecture** principles with a feature-based folder structure.

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Screens    │  │    Cubit     │  │    States    │  │
│  │  (Flutter)   │◄─┤(Business Logic)◄┤  (Equatable) │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                      Domain Layer                        │
│  ┌──────────────────────────────────────────────────┐   │
│  │              Repository (Interface)              │   │
│  │        (Defines what operations are available)   │   │
│  └──────────────────────────────────────────────────┘   │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│                       Data Layer                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Models     │  │  Repository  │  │ APIRequest   │  │
│  │ (fromJson/   │  │(Implementation)◄┤(DioProvider) │  │
│  │   toJson)    │  │              │  │              │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
                  ┌──────────────┐
                  │   Backend    │
                  │  Laravel API │
                  └──────────────┘
```

---

## 📂 Folder Structure Deep Dive

### Complete Feature Structure
```
lib/features/booking/
│
├── models/                                    # Data Transfer Objects (DTOs)
│   ├── booking_model.dart                    # Core domain model
│   │   ├── BookingModel                      # Main booking entity
│   │   ├── ParkingLotInfo                    # Nested: parking lot details
│   │   ├── VehicleInfo                       # Nested: vehicle details
│   │   └── PaymentInfo                       # Nested: payment details
│   │
│   ├── Request Models (Input)
│   │   ├── create_booking_request.dart
│   │   ├── extend_booking_request.dart
│   │   └── payment_request.dart
│   │
│   └── Response Models (Output)
│       ├── create_booking_response.dart
│       ├── cancel_booking_response.dart
│       ├── extend_booking_response.dart
│       ├── payment_response.dart
│       ├── bookings_list_response.dart
│       ├── booking_details_response.dart
│       ├── remaining_time_response.dart
│       └── payments_list_response.dart
│
├── repository/                                # Data Access Layer
│   └── booking_repository.dart               # API calls implementation
│       ├── createBooking()
│       ├── cancelBooking()
│       ├── extendBooking()
│       ├── processPaymentSuccess()
│       ├── processPaymentFailure()
│       ├── getActiveBookings()
│       ├── getFinishedBookings()
│       ├── getBookingDetails()
│       ├── getRemainingTime()
│       ├── getPaymentHistory()
│       └── downloadBookingPdf()
│
├── cubit/                                     # State Management (BLoC pattern)
│   ├── booking_cubit.dart                    # Business logic
│   │   ├── createBooking()
│   │   ├── cancelBooking()
│   │   ├── extendBooking()
│   │   ├── processPaymentSuccess()
│   │   ├── processPaymentFailure()
│   │   ├── getActiveBookings()
│   │   ├── getFinishedBookings()
│   │   ├── getBookingDetails()
│   │   ├── getRemainingTime()
│   │   ├── getPaymentHistory()
│   │   └── downloadBookingPdf()
│   │
│   └── booking_state.dart                    # All state definitions
│       ├── BookingInitial
│       ├── CreateBooking States (Loading, Success, Error)
│       ├── CancelBooking States (Loading, Success, Error)
│       ├── ExtendBooking States (Loading, Success, Error)
│       ├── ProcessPayment States (Loading, Success, Error)
│       ├── GetActiveBookings States (Loading, Success, Error)
│       ├── GetFinishedBookings States (Loading, Success, Error)
│       ├── GetBookingDetails States (Loading, Success, Error)
│       ├── GetRemainingTime States (Loading, Success, Error)
│       ├── GetPaymentHistory States (Loading, Success, Error)
│       └── DownloadBookingPdf States (Loading, Success, Error)
│
├── presentation/                              # UI Layer (to be created)
│   ├── pages/
│   │   ├── active_bookings_screen.dart
│   │   ├── finished_bookings_screen.dart
│   │   ├── booking_details_screen.dart
│   │   ├── create_booking_screen.dart
│   │   └── payment_screen.dart
│   │
│   └── widgets/
│       ├── booking_card.dart
│       ├── booking_status_badge.dart
│       ├── payment_method_selector.dart
│       └── remaining_time_widget.dart
│
└── booking.dart                               # Barrel file (exports all)
```

---

## 🔄 Data Flow

### Example: Creating a Booking

```
1. USER ACTION
   └─> User taps "Create Booking" button

2. UI LAYER (Presentation)
   └─> Calls: context.read<BookingCubit>().createBooking(...)

3. CUBIT (Business Logic)
   ├─> Emits: CreateBookingLoading
   ├─> Creates: CreateBookingRequest model
   └─> Calls: BookingRepository.createBooking(request)

4. REPOSITORY (Data Access)
   ├─> Creates: APIRequest object
   ├─> Sets: endpoint, method, body, auth
   └─> Calls: request.send()

5. API REQUEST (Network Layer)
   ├─> Gets token from AuthLocalRepository
   ├─> Adds: Authorization header
   ├─> Uses: DioProvider.instance.request()
   └─> Sends: HTTP POST to backend

6. BACKEND (Laravel API)
   ├─> Validates request
   ├─> Checks parking lot availability
   ├─> Creates booking in database
   └─> Returns: JSON response

7. RESPONSE HANDLING
   ├─> DioProvider handles response
   ├─> Repository parses JSON
   ├─> Creates: CreateBookingResponse model
   └─> Returns to Cubit

8. CUBIT (Business Logic)
   └─> Emits: CreateBookingSuccess(response)
          OR CreateBookingError(message)

9. UI LAYER (Presentation)
   ├─> BlocConsumer listens to state
   ├─> Shows: SnackBar with success message
   └─> Navigates: to Payment screen
```

---

## 🧩 Component Responsibilities

### 1. **Models** (Data Transfer Objects)
- **Purpose**: Define data structure
- **Responsibilities**:
  - Parse JSON to Dart objects (`fromJson`)
  - Convert Dart objects to JSON (`toJson`)
  - Provide type-safe data access
  - Safe parsing with fallback values
- **Examples**: `BookingModel`, `CreateBookingRequest`

### 2. **Repository** (Data Access Layer)
- **Purpose**: Abstract API communication
- **Responsibilities**:
  - Define API endpoints
  - Create API requests
  - Handle HTTP responses
  - Parse response data to models
  - Throw `AppException` on errors
- **Pattern**: Static methods (stateless)
- **Example**:
  ```dart
  static Future<CreateBookingResponse> createBooking({
    required CreateBookingRequest request,
  }) async {
    // Implementation
  }
  ```

### 3. **Cubit** (Business Logic)
- **Purpose**: Manage application state
- **Responsibilities**:
  - Call repository methods
  - Emit appropriate states
  - Handle errors
  - Transform data if needed
- **Pattern**: Extends `Cubit<BookingState>`
- **Example**:
  ```dart
  Future<void> createBooking({...}) async {
    emit(const CreateBookingLoading());
    try {
      final response = await BookingRepository.createBooking(...);
      emit(CreateBookingSuccess(response));
    } on AppException catch (e) {
      emit(CreateBookingError(message: e.message, ...));
    }
  }
  ```

### 4. **States** (UI State Definitions)
- **Purpose**: Define all possible UI states
- **Responsibilities**:
  - Represent loading, success, error states
  - Hold response data
  - Provide helper methods (e.g., `isEmpty`)
- **Pattern**: Immutable classes extending `Equatable`
- **Example**:
  ```dart
  class CreateBookingSuccess extends BookingState {
    final CreateBookingResponse response;
    const CreateBookingSuccess(this.response);
  }
  ```

### 5. **Presentation** (UI Layer - To be implemented)
- **Purpose**: Display data to user
- **Responsibilities**:
  - Build widgets based on states
  - Handle user interactions
  - Navigate between screens
  - Show dialogs, snackbars
- **Pattern**: `BlocConsumer` or `BlocBuilder` + `BlocListener`

---

## 🔐 Authentication Flow

```
┌──────────────────────────────────────────────────────┐
│ 1. User logs in                                      │
│    └─> Token saved in SharedPreferences             │
└────────────────────────┬─────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│ 2. User calls booking API                            │
│    └─> APIRequest created with                      │
│        authorizationOption: authorized               │
└────────────────────────┬─────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│ 3. APIRequest.send() called                          │
│    ├─> Gets token from AuthLocalRepository          │
│    ├─> Cleans token (trim, remove newlines)         │
│    └─> Adds: 'Authorization': 'Bearer $token'       │
└────────────────────────┬─────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│ 4. Request sent to backend                           │
│    └─> Laravel Sanctum validates token              │
└────────────────────────┬─────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────┐
│ 5. Backend response                                  │
│    ├─> Success: Returns data                        │
│    └─> 401: Token invalid/expired                   │
│        └─> DioProvider throws AppException          │
│            └─> UI redirects to login                │
└──────────────────────────────────────────────────────┘
```

---

## 🚨 Error Handling Architecture

```
┌─────────────────────────────────────────────────┐
│              Error Source                       │
│  (Network, Backend, Validation, Unexpected)     │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│          DioProvider (Network Layer)            │
│  ┌──────────────────────────────────────────┐   │
│  │ Catches: DioException                    │   │
│  │ Converts to: AppException                │   │
│  │ Includes:                                │   │
│  │   - statusCode (HTTP status)             │   │
│  │   - errorCode (machine-readable)         │   │
│  │   - message (user-friendly)              │   │
│  │   - errors (field-specific validation)   │   │
│  └──────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│          Repository (Data Layer)                │
│  ┌──────────────────────────────────────────┐   │
│  │ try { ... }                              │   │
│  │ on AppException {                        │   │
│  │   rethrow;  // Pass to Cubit            │   │
│  │ }                                        │   │
│  └──────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│            Cubit (Business Logic)               │
│  ┌──────────────────────────────────────────┐   │
│  │ try { ... }                              │   │
│  │ on AppException catch (e) {              │   │
│  │   emit(ErrorState(                       │   │
│  │     message: e.message,                  │   │
│  │     statusCode: e.statusCode,            │   │
│  │     errorCode: e.errorCode,              │   │
│  │     validationErrors: e.errors,          │   │
│  │   ));                                    │   │
│  │ }                                        │   │
│  └──────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────┐
│         UI Layer (Presentation)                 │
│  ┌──────────────────────────────────────────┐   │
│  │ BlocListener<BookingCubit, BookingState> │   │
│  │   if (state is ErrorState) {             │   │
│  │     // Show SnackBar                     │   │
│  │     // Show Dialog                       │   │
│  │     // Display inline errors             │   │
│  │     // Redirect if 401 (Unauthorized)    │   │
│  │   }                                      │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

---

## 🌐 Localization Architecture

### ARB File Structure
```
lib/l10n/
├── app_en.arb                    # English translations
├── app_ar.arb                    # Arabic translations
└── (Generated by flutter gen-l10n)
    ├── app_localizations.dart
    ├── app_localizations_en.dart
    └── app_localizations_ar.dart
```

### Usage in Code
```dart
// 1. Import generated localization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 2. Access in widget
final l10n = AppLocalizations.of(context)!;

// 3. Use localized strings
Text(l10n.bookingTitle)           // "Booking" (EN) | "الحجز" (AR)
Text(l10n.activeBookings)         // "Active Bookings" (EN) | "الحجوزات النشطة" (AR)
```

### Key Naming Convention
```
{feature}{Action}{Property}

Examples:
- bookingTitle              (Feature title)
- createBooking             (Action)
- bookingCreatedSuccess     (Success message)
- cancelBooking             (Action)
- activeBookings            (Section)
- noActiveBookings          (Empty state)
- statusActive              (Status value)
- paymentMethodCash         (Payment method value)
```

---

## 🔄 State Management Flow

### BLoC Pattern with Cubit

```
                  ┌──────────────────┐
                  │   User Action    │
                  │  (Button Tap)    │
                  └────────┬─────────┘
                           │
                           ▼
                  ┌──────────────────┐
                  │  Cubit Method    │
                  │  (createBooking) │
                  └────────┬─────────┘
                           │
                           ├─> emit(LoadingState)
                           │
                           ├─> Call Repository
                           │
                           ├─> await Response
                           │
                           └─> emit(SuccessState) or emit(ErrorState)
                                        │
                                        ▼
                  ┌──────────────────────────────────┐
                  │        BlocBuilder               │
                  │  Rebuilds UI based on new state  │
                  └──────────────────────────────────┘
                                        │
                                        ▼
                  ┌──────────────────────────────────┐
                  │       BlocListener               │
                  │  Performs side effects           │
                  │  (Navigation, SnackBar, etc.)    │
                  └──────────────────────────────────┘
```

### Why Cubit over Bloc?
- **Simpler**: No events, just methods
- **Less boilerplate**: Fewer files and classes
- **Easier to test**: Direct method calls
- **Still follows BLoC pattern**: Emits states, UI reacts

---

## 📦 Dependencies

### Core Dependencies (Already in project)
```yaml
dependencies:
  flutter_bloc: ^8.1.6          # State management
  equatable: ^2.0.5             # Value equality for states
  dio: ^5.4.0                   # HTTP client
  get_it: ^7.7.0                # Dependency injection
  flutter_localizations:        # Localization support
  intl: ^0.20.2                 # Internationalization
```

### Why These Dependencies?

- **flutter_bloc**: Industry-standard state management, predictable, testable
- **equatable**: Simplifies state comparison, prevents unnecessary rebuilds
- **dio**: Powerful HTTP client with interceptors, error handling, file download
- **get_it**: Service locator for dependency injection, decouples code
- **flutter_localizations + intl**: Official Flutter localization solution

---

## 🧪 Testing Strategy

### Unit Tests (Models)
```dart
test('BookingModel.fromJson creates valid object', () {
  final json = {...};
  final booking = BookingModel.fromJson(json);
  expect(booking.bookingId, equals(1));
});
```

### Unit Tests (Repository)
```dart
test('createBooking returns CreateBookingResponse on success', () async {
  // Mock APIRequest
  // Call repository method
  // Verify response type and data
});
```

### Unit Tests (Cubit)
```dart
blocTest<BookingCubit, BookingState>(
  'emits [Loading, Success] when createBooking succeeds',
  build: () => BookingCubit(),
  act: (cubit) => cubit.createBooking(...),
  expect: () => [
    isA<CreateBookingLoading>(),
    isA<CreateBookingSuccess>(),
  ],
);
```

### Widget Tests
```dart
testWidgets('shows loading indicator when creating booking', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider(
        create: (_) => BookingCubit(),
        child: CreateBookingScreen(),
      ),
    ),
  );
  
  await tester.tap(find.text('Create Booking'));
  await tester.pump();
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

---

## 🎯 Design Principles Applied

### 1. **Single Responsibility Principle**
- Models: Only data structure and parsing
- Repository: Only API communication
- Cubit: Only business logic
- UI: Only presentation

### 2. **Dependency Inversion**
- UI depends on Cubit (abstraction), not Repository
- Cubit depends on Repository interface, not implementation

### 3. **Open/Closed Principle**
- Easy to add new endpoints without modifying existing code
- New states can be added without changing Cubit logic

### 4. **DRY (Don't Repeat Yourself)**
- `APIRequest` centralizes all HTTP logic
- Models have reusable parsing helpers
- Barrel file (`booking.dart`) simplifies imports

### 5. **Separation of Concerns**
- Network layer (Dio) separate from business logic (Cubit)
- State definitions separate from state management logic
- Localization separate from UI code

---

## 🚀 Performance Considerations

### 1. **Efficient State Management**
- Equatable prevents unnecessary rebuilds
- BlocConsumer splits side effects from UI building

### 2. **Network Optimization**
- Dio connection pooling and keep-alive
- Request timeouts prevent hanging
- Automatic retry on connection errors

### 3. **Memory Management**
- Models are immutable (const constructors)
- Cubit reset on screen disposal
- No memory leaks from state holding large objects

### 4. **Lazy Loading**
- Cubits registered as factory (new instance per request)
- Repository methods are static (no instance creation)

---

## 📊 Metrics & Monitoring

### Recommended Tracking
1. **API Performance**
   - Average response time per endpoint
   - Success/failure rates
   
2. **User Actions**
   - Booking creation success rate
   - Cancellation frequency
   - Payment completion rate

3. **Errors**
   - Track error codes and frequencies
   - Monitor 401 errors (auth issues)
   - Alert on 500 errors (backend issues)

---

## 🔮 Future Enhancements

### Potential Additions
1. **Pagination** for booking lists
2. **Real-time updates** with WebSockets
3. **Offline support** with local caching (Hive)
4. **Push notifications** for booking reminders
5. **Analytics integration** for user behavior tracking

---

**Last Updated**: 2026-01-24

