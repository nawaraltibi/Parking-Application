# 📊 lib2 Bloc Architecture Analysis

## 🎯 Key Findings

### **Architecture Pattern: Full Bloc (Not Cubit)**

lib2 uses **Bloc** (not Cubit) throughout the entire project with a consistent, well-defined pattern.

---

## 🏗️ Bloc Structure Pattern

### **1. Folder Organization**
```
feature/
├── bloc/
│   ├── feature_name/
│   │   ├── feature_name_bloc.dart    (main file with part directives)
│   │   ├── feature_name_event.dart   (part of bloc)
│   │   └── feature_name_state.dart   (part of bloc)
│   └── sub_feature/
│       ├── sub_feature_bloc.dart
│       ├── sub_feature_event.dart
│       └── sub_feature_state.dart
├── models/
├── repository/
└── presentation/
```

### **2. File Structure with `part` Directives**

**Main Bloc File:**
```dart
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// other imports...

part 'feature_event.dart';
part 'feature_state.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  // implementation
}
```

**Event File:**
```dart
part of 'feature_bloc.dart';

abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
  
  @override
  List<Object?> get props => [];
}

class SomeEvent extends FeatureEvent {
  // implementation
}
```

**State File:**
```dart
part of 'feature_bloc.dart';

abstract class FeatureState extends Equatable {
  const FeatureState();
  
  @override
  List<Object?> get props => [];
}

class SomeState extends FeatureState {
  // implementation
}
```

---

## 🎨 State Management Patterns

### **Pattern 1: Simple State Pattern (Home Bloc)**
```dart
// States: Initial → Loading → Loaded/Error
abstract class HomeState extends Equatable {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final Statistics statistics;
  final List<Attendance> attendance;
  // ...
}
class HomeError extends HomeState {
  final String message;
  // ...
}
```

**Characteristics:**
- ✅ Simple state hierarchy
- ✅ No form data preservation
- ✅ Clear loading/success/error flow
- ✅ Equatable for efficient comparison

### **Pattern 2: Form-Preserving State Pattern (Tickets Bloc)**
```dart
// Form model shared across all states
class TicketsForm extends Equatable {
  final TicketsMethod method;
  final String searchQuery;
  final String? scannedCode;
  
  const TicketsForm({...});
  const TicketsForm.initial() : ...;
  
  TicketsForm copyWith({...}) => ...;
}

// All states extend base with form
abstract class TicketsState extends Equatable {
  final TicketsForm form;
  const TicketsState(this.form);
}

class TicketsIdle extends TicketsState {}
class TicketsSubmitting extends TicketsState {}
class TicketsSuccess extends TicketsState {
  final String message;
  // ...
}
class TicketsFailure extends TicketsState {
  final String errorMessage;
  // ...
}
```

**Characteristics:**
- ✅ Form data preserved across all states
- ✅ Idle → Submitting → Success/Failure flow
- ✅ Form has `copyWith` for immutability
- ✅ States: Idle, Submitting, Success, Failure

### **Pattern 3: Request-Preserving State Pattern (Registration Bloc)**
```dart
// All states preserve the request model
abstract class RegistrationRequestState {
  final RegistrationRequest request;
  const RegistrationRequestState({required this.request});
}

class RegistrationRequestInitial extends RegistrationRequestState {}
class RegistrationRequestLoading extends RegistrationRequestState {}
class RegistrationRequestSuccess extends RegistrationRequestState {
  final String message;
  // ...
}
class RegistrationRequestFailure extends RegistrationRequestState {
  final String error;
  // ...
}
```

**Characteristics:**
- ✅ Request model preserved in all states
- ✅ Initial → Loading → Success/Failure flow
- ✅ Helper method `_updateStateWithRequest()` to preserve state type
- ✅ Does NOT use Equatable (simpler comparison)

---

## 📝 Event Patterns

### **Event Conventions:**
1. **Abstract base class** with Equatable
2. **Const constructors** for all events
3. **Override props** for value equality
4. **Descriptive names** (verb-based)

```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
  
  @override
  List<Object?> get props => [];
}

// Form update events
class UpdateField extends FeatureEvent {
  final String value;
  const UpdateField(this.value);
  
  @override
  List<Object?> get props => [value];
}

// Action events
class SubmitForm extends FeatureEvent {
  const SubmitForm();
}

// Reset events
class ResetState extends FeatureEvent {
  const ResetState();
}
```

---

## 🔄 Bloc Implementation Patterns

### **Pattern 1: Event Handler Registration**
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc() : super(const FeatureInitial()) {
    on<Event1>(_onEvent1);
    on<Event2>(_onEvent2);
    on<Event3>(_onEvent3);
  }
  
  void _onEvent1(Event1 event, Emitter<FeatureState> emit) {
    // synchronous handler
  }
  
  Future<void> _onEvent2(Event2 event, Emitter<FeatureState> emit) async {
    // asynchronous handler
  }
}
```

### **Pattern 2: AsyncRunner Integration**
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final AsyncRunner<ResponseType> _runner = AsyncRunner<ResponseType>();
  
  Future<void> _onSubmit(Submit event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    
    await _runner.run(
      onlineTask: (_) async {
        return await Repository.fetchData();
      },
      offlineTask: (_) async {
        return await Repository.fetchDataFromLocal();
      },
      onSuccess: (data) async {
        if (!emit.isDone) {
          emit(FeatureSuccess(data: data));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          emit(FeatureError(error.toString()));
        }
      },
    );
  }
}
```

**AsyncRunner Features:**
- ✅ Handles online/offline scenarios
- ✅ Automatic connectivity checking
- ✅ Queue support for offline operations
- ✅ Prevents emitting after bloc is closed (`emit.isDone` check)

---

## 🛡️ Error Handling Patterns

### **1. Validation Errors**
```dart
Future<void> _onSubmit(Submit event, Emitter<State> emit) async {
  // Validate before processing
  if (state.request.field.isEmpty) {
    emit(FeatureFailure(
      request: state.request,
      error: 'fill_all_fields', // Translation key
    ));
    return;
  }
  
  // Continue with submission...
}
```

### **2. API Errors**
```dart
await _runner.run(
  onlineTask: (_) async => await Repository.submit(),
  onSuccess: (response) async {
    // Check for logical errors in success response
    if (response.message.toLowerCase().contains('forbidden')) {
      emit(FeatureFailure(error: response.message));
    } else {
      emit(FeatureSuccess(message: response.message));
    }
  },
  onError: (error) {
    emit(FeatureFailure(error: error.toString()));
  },
);
```

### **3. Emit Safety**
```dart
// Always check emit.isDone before emitting in async callbacks
if (!emit.isDone) {
  emit(SomeState());
}
```

---

## 🌍 Localization Pattern

### **Error Messages as Translation Keys**
```dart
// In Bloc - use key strings
emit(FeatureFailure(error: 'fill_all_fields'));
emit(FeatureFailure(error: 'invalid_input'));

// In UI - translate using l10n
BlocListener<FeatureBloc, FeatureState>(
  listener: (context, state) {
    if (state is FeatureFailure) {
      final l10n = AppLocalizations.of(context)!;
      final message = _translateError(state.error, l10n);
      showSnackBar(message);
    }
  },
)

String _translateError(String error, AppLocalizations l10n) {
  switch (error) {
    case 'fill_all_fields':
      return l10n.fillAllFields;
    case 'invalid_input':
      return l10n.invalidInput;
    default:
      return error; // Return as-is if not a key
  }
}
```

---

## 🎯 State Transition Patterns

### **Pattern 1: Simple Flow (Home)**
```
Initial → Loading → Loaded/Error
```

### **Pattern 2: Form Flow (Tickets)**
```
Idle ⟷ (form updates) ⟷ Idle
  ↓
Submitting
  ↓
Success/Failure → (reset) → Idle
```

### **Pattern 3: Request Flow (Registration)**
```
Initial ⟷ (field updates) ⟷ Initial
  ↓
Loading
  ↓
Success/Failure → (reset) → Initial
```

---

## 📦 Key Differences: Bloc vs Cubit

| Aspect | Cubit (Your Current Code) | Bloc (lib2 Pattern) |
|--------|---------------------------|---------------------|
| **Events** | ❌ No events, direct methods | ✅ Events for all actions |
| **File Structure** | Single file per cubit | 3 files (bloc, event, state) with `part` |
| **Testability** | Good | Excellent (events are testable) |
| **Traceability** | Method calls | Event stream (easier debugging) |
| **Boilerplate** | Less | More (but more explicit) |
| **Best For** | Simple features | Complex features with multiple actions |

---

## 🏆 lib2 Best Practices

### ✅ **DO:**
1. Use **Bloc** (not Cubit) for all features
2. Use **`part` directives** for event/state files
3. Use **Equatable** for states (and events when needed)
4. Use **const constructors** everywhere
5. Preserve **form/request data** in states when needed
6. Use **AsyncRunner** for API calls
7. Check **`emit.isDone`** before emitting in async callbacks
8. Use **translation keys** for error messages
9. Validate **before** emitting loading state
10. Have **dedicated Blocs** for different operations

### ❌ **DON'T:**
1. Don't mix Cubit and Bloc patterns
2. Don't emit states without checking `emit.isDone` in async
3. Don't hardcode user-facing messages in Bloc
4. Don't forget to override `props` in Equatable classes
5. Don't create monolithic Blocs (split by operation)

---

## 📊 Bloc Naming Conventions

### **Files:**
- `feature_bloc.dart` (main file)
- `feature_event.dart` (part of bloc)
- `feature_state.dart` (part of bloc)

### **Classes:**
- Bloc: `FeatureBloc`
- Events: `LoadFeature`, `UpdateField`, `SubmitForm`, `ResetState`
- States: `FeatureInitial`, `FeatureLoading`, `FeatureLoaded`, `FeatureError`

### **Form/Request Models:**
- `FeatureForm` (for UI forms)
- `FeatureRequest` (for API requests)

---

## 🔧 AsyncRunner Pattern

```dart
final AsyncRunner<ResponseType> _runner = AsyncRunner<ResponseType>();

await _runner.run(
  // Online task (with internet)
  onlineTask: (previousResult) async {
    return await Repository.fetchOnline(enableQueue: false);
  },
  
  // Offline task (no internet)
  offlineTask: (previousResult) async {
    return await Repository.fetchOffline(enableQueue: true);
  },
  
  // Enable connectivity check
  checkConnectivity: true,
  
  // Success callback
  onSuccess: (result) async {
    if (!emit.isDone) {
      emit(FeatureSuccess(data: result));
    }
  },
  
  // Offline callback (when using cached data)
  onOffline: (result) async {
    if (!emit.isDone) {
      emit(FeatureLoaded(data: result, isOffline: true));
    }
  },
  
  // Error callback
  onError: (error) async {
    if (!emit.isDone) {
      emit(FeatureError(error.toString()));
    }
  },
);
```

---

## 📝 Summary

### **Core Principles:**
1. **Full Bloc Pattern** - Events for all actions
2. **File Organization** - 3 files with `part` directives
3. **State Preservation** - Form/request data in states
4. **AsyncRunner** - Consistent async handling
5. **Equatable** - Efficient state comparison
6. **Const Everything** - Immutability
7. **Translation Keys** - Localization-ready errors
8. **Emit Safety** - Check `emit.isDone` in async

### **State Patterns:**
- **Simple**: Initial → Loading → Loaded/Error
- **Form**: Idle ⟷ updates ⟷ Submitting → Success/Failure
- **Request**: Initial ⟷ updates ⟷ Loading → Success/Failure

---

**Next Step:** Refactor Parking App Booking feature from Cubit to Bloc following these patterns.

