# Implementation Guides

## State Management with Cubit

### Creating a New Cubit

```dart
// 1. Define States
abstract class YourState {}
class YourInitialState extends YourState {}
class YourLoadingState extends YourState {}
class YourLoadedState extends YourState {
  final YourEntity data;
  YourLoadedState({required this.data});
}
class YourErrorState extends YourState {
  final String message;
  YourErrorState({required this.message});
}

// 2. Create Cubit (Method-Based - No Events)
class YourCubit extends Cubit<YourState> {
  final GetYourDataUseCase getYourDataUseCase;

  YourCubit({required this.getYourDataUseCase}) : super(YourInitialState());

  // Direct method call - no events needed
  Future<void> getYourData() async {
    emit(YourLoadingState());
    final result = await getYourDataUseCase();

    result.fold(
      (failure) => emit(YourErrorState(message: failure.message)),
      (data) => emit(YourLoadedState(data: data)),
    );
  }
}
```

### Using Cubit in UI

```dart
// Read state
BlocBuilder<YourCubit, YourState>(
  builder: (context, state) {
    if (state is YourLoadingState) {
      return const CircularProgressIndicator();
    } else if (state is YourLoadedState) {
      return Text(state.data.title);
    } else if (state is YourErrorState) {
      return Text('Error: ${state.message}');
    }
    return const SizedBox();
  },
);

// Trigger action directly (no events)
context.read<YourCubit>().getYourData();
```

---

## Navigation with GoRouter

### Route Definition

```dart
// In lib/core/routes/route_names.dart - Define routes as enum

enum RoutesName {
  splash(path: '/splash', name: 'Splash Page'),
  home(path: '/home', name: 'Home Page'),
  homeDetail(path: '/home/detail/:id', name: 'Home Detail'),
  ;

  const RoutesName({required this.path, required this.name});

  final String path;
  final String name;
}
```

### Using Routes in GoRouter

```dart
// In lib/core/routes/app_routes.dart

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: RoutesName.splash.path,
    routes: [
      // Splash route
      GoRoute(
        name: RoutesName.splash.name,
        path: RoutesName.splash.path,
        pageBuilder: (context, state) =>
            CustomTransitions.buildPageWithDefaultTransition<SplashPage>(
              context: context,
              state: state,
              child: const SplashPage(),
              transitionType: TransitionType.fade,
            ),
      ),
      
      // Home route with sub-routes
      GoRoute(
        name: RoutesName.home.name,
        path: RoutesName.home.path,
        pageBuilder: (context, state) =>
            CustomTransitions.buildPageWithDefaultTransition<HomePage>(
              context: context,
              state: state,
              child: BlocProvider<HomeCubit>(
                create: (context) => sl<HomeCubit>(),
                child: const HomePage(),
              ),
              transitionType: TransitionType.fade,
            ),
        routes: [
          // Detail route with ID parameter
          GoRoute(
            name: RoutesName.homeDetail.name,
            path: 'detail/:id',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return CustomTransitions.buildPageWithDefaultTransition<HomeDetailPage>(
                context: context,
                state: state,
                child: HomeDetailPage(id: id),
                transitionType: TransitionType.fade,
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Route not found: ${state.uri}')),
      );
    },
  );
}
```

### Navigating to Routes

```dart
// Simple navigation
context.go(RoutesName.home.path);

// With parameters
context.go('${RoutesName.home.path}/detail/123');

// Named route navigation
context.goNamed(RoutesName.homeDetail.name, pathParameters: {'id': '123'});

// Replace route (removes previous from stack)
context.replace(RoutesName.home.path);

// Push route (adds to stack)
context.push('${RoutesName.home.path}/detail/456');
```

---

## Localization with Easy Localization

### Using Translations in Code (Type-Safe Approach - Recommended)

```dart
import 'package:touch/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// Use generated LocaleKeys for type-safe translations
Text(LocaleKeys.home_title.tr()); // Compiler checks if key exists
Text('${LocaleKeys.error.tr()}: ${errorMessage}');

// Get current locale
final currentLocale = EasyLocalization.of(context)?.locale;

// Change language
EasyLocalization.of(context)?.setLocale(const Locale('ar'));
```

### Generating LocaleKeys

After adding new translations, generate the LocaleKeys file:

```bash
dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations
```

Generated file location: `lib/generated/locale_keys.g.dart`

### Adding New Translations

Edit `assets/translations/en.json` and `assets/translations/ar.json`:

```json
{
  "key": "English value",
  "key_with_params": "Hello {}"
}
```

**Important:** After adding new keys, run the generation command above to update `LocaleKeys`.

---

## Dependency Injection with GetIt

### Registering Dependencies

```dart
// In service_locator.dart

// Singleton - single instance throughout the app
getIt.registerSingleton<YourClass>(YourClass());

// Lazy Singleton - created on first access
getIt.registerLazySingleton<YourClass>(() => YourClass());

// Factory - new instance each time
getIt.registerSingleton<YourClass>(() => YourClass());
```

### Accessing Dependencies

```dart
// Using sl directly
final myClass = sl<MyClass>();

// In Cubits/Services, it's already injected via constructor
class MyCubit extends Cubit<MyState> {
  final MyService service;
  
  MyCubit({required this.service}) : super(Initial());
}
```

---

## Network Error Handling with DioExceptionHandler

### Overview
Errors flow through layers: **DioClient → DataSource → Repository → Cubit**

### Layer Responsibilities

**1. DioClient (Network Layer)**
- Makes HTTP requests
- Uses PrettyDioLogger for debugging
- Injects access tokens via TokenInterceptor

**2. DioExceptionHandler (Error Converter)**
- Converts `DioException` to domain `Failure` classes
- Maps HTTP status codes to meaningful errors
- Centralized error handling logic

**3. DataSource (Data Access)**
- Calls DioClient methods
- Catches `DioException` and converts to `Failure`
- Throws `Failure` (not raw exceptions)

**4. Repository (Business Logic)**
- Calls DataSource
- Catches `Failure` and wraps in `Either`
- Returns `Either<Failure, Success>` to domain layer

**5. Cubit (Presentation)**
- Calls Repository use cases
- Uses `.fold()` to handle success/failure
- Emits appropriate states to UI

### Example Implementation

#### File Organization

**Default (Remote Only):**
```
lib/features/feature_name/data/datasources/
└── user_remote_data_source.dart
```

**With Local Caching (Optional):**
```
lib/features/feature_name/data/datasources/
├── user_remote_data_source.dart
└── user_local_data_source.dart
```

#### Remote DataSource

**File: `lib/features/feature_name/data/datasources/user_remote_data_source.dart`**

```dart
import 'package:dio/dio.dart';
import 'package:touch/core/network/dio_exception_handler.dart';

// Abstract interface
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> createUser(UserModel user);
}

// Implementation
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUser(String id) async {
    try {
      final response = await dioClient.get(path: '/users/$id');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      // Convert DioException to Failure and throw
      throw DioExceptionHandler.fromDioException(e);
    }
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await dioClient.get(path: '/users');
      final users = (response.data as List)
          .map((user) => UserModel.fromJson(user))
          .toList();
      return users;
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await dioClient.post(
        path: '/users',
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }
}
```

#### Local DataSource

**File: `lib/features/feature_name/data/datasources/user_local_data_source.dart`**

```dart
import 'dart:convert';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/services/secure_storage_service.dart';

// Abstract interface
abstract class UserLocalDataSource {
  Future<UserModel> getCachedUser(String id);
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
}

// Implementation
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SecureStorageService secureStorage;
  static const _userCacheKey = 'cached_user_';

  UserLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<UserModel> getCachedUser(String id) async {
    try {
      final cachedData = await secureStorage.read(key: '$_userCacheKey$id');
      if (cachedData == null) {
        throw CacheFailure(message: 'No cached user found');
      }
      return UserModel.fromJson(jsonDecode(cachedData));
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure(message: 'Failed to retrieve cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await secureStorage.write(
        key: '$_userCacheKey${user.id}',
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.deleteAll();
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: $e');
    }
  }
}
```

#### Using Both DataSources in Repository

**File: `lib/features/feature_name/data/repositories/user_repository_impl.dart`**

```dart
import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      // Try to fetch from remote first
      final userModel = await remoteDataSource.getUser(id);
      
      // Cache locally for offline access
      await localDataSource.cacheUser(userModel);
      
      return Right(userModel.toEntity());
    } on Failure catch (failure) {
      // If remote fails, try to get from local cache
      try {
        final cachedUserModel = await localDataSource.getCachedUser(id);
        return Right(cachedUserModel.toEntity());
      } catch (_) {
        // Both remote and local failed
        return Left(failure);
      }
    }
  }
}
```

#### Registering DataSources in Service Locator

**File: `lib/service_locator.dart`**

```dart
// Remote DataSource
getIt.registerLazySingleton<UserRemoteDataSource>(
  () => UserRemoteDataSourceImpl(dioClient: getIt<DioClient>()),
);

// Local DataSource
getIt.registerLazySingleton<UserLocalDataSource>(
  () => UserLocalDataSourceImpl(secureStorage: getIt<FlutterSecureStorage>()),
);

// Repository (depends on both DataSources)
getIt.registerLazySingleton<UserRepository>(
  () => UserRepositoryImpl(
    remoteDataSource: getIt<UserRemoteDataSource>(),
    localDataSource: getIt<UserLocalDataSource>(),
  ),
);
```

### Failure Classes

```dart
// In lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ServerFailure extends Failure {
  ServerFailure({required String message}) : super(message: message);
  // 400, 401, 403, 404, 500, etc.
}

class NetworkFailure extends Failure {
  NetworkFailure({required String message}) : super(message: message);
  // Timeout, connection error, unknown error, etc.
}

class ValidationFailure extends Failure {
  ValidationFailure({required String message}) : super(message: message);
}

class UnknownFailure extends Failure {
  UnknownFailure({String message = 'An unknown error occurred'})
      : super(message: message);
}
```

### Error Mapping Examples

| Error Type | Status Code | Mapped Failure | Message |
|------------|------------|----------------|---------|
| Timeout | - | NetworkFailure | Connection timeout. Please check your internet connection. |
| Connection Error | - | NetworkFailure | No internet connection. Please check your network. |
| Bad Request | 400 | ServerFailure | Bad request. Please check your input. |
| Unauthorized | 401 | ServerFailure | Unauthorized. Please log in again. |
| Forbidden | 403 | ServerFailure | Forbidden. You do not have permission. |
| Not Found | 404 | ServerFailure | Resource not found. |
| Server Error | 500, 502, 503, 504 | ServerFailure | Server error. Please try again later. |

---

## DataSource Organization & Best Practices

### File Structure

Always organize DataSources in separate files for maintainability:

```
lib/features/[feature_name]/data/datasources/
├── remote/
│   ├── user_remote_data_source.dart       # Abstract class
│   └── user_remote_data_source_impl.dart  # Implementation (optional)
└── local/
    ├── user_local_data_source.dart        # Abstract class
    └── user_local_data_source_impl.dart   # Implementation (optional)
```

### Separation Principles

#### 1. **Remote DataSource** - API Calls
- Handles HTTP requests via DioClient
- Manages network-related operations
- Catches DioException and converts to Failure
- File: `user_remote_data_source.dart`

#### 2. **Local DataSource** - Local Storage
- Manages caching with FlutterSecureStorage or SharedPreferences
- Handles offline data persistence
- No network operations
- File: `user_local_data_source.dart`

#### 3. **Abstract Classes**
- Define contracts for implementations
- Allow repository to work with either data source
- Enable easy testing with mocks

### Why Separate DataSources?

✅ **Single Responsibility** - Each class has one reason to change
✅ **Testability** - Easy to mock individual data sources
✅ **Reusability** - Switch between remote/local easily
✅ **Maintainability** - Clear code organization
✅ **Offline Support** - Implement fallback to local cache

### Usage Pattern

The repository typically:
1. **Tries remote first** - Fetch fresh data from API
2. **Caches locally** - Save data for offline access
3. **Falls back to local** - Use cached data if remote fails

See the Example Implementation section above for complete code examples.

---

## Error Handling with Dartz Either

### Using Either Pattern

```dart
// Function returns Either<Failure, Success>
Future<Either<Failure, HomeEntity>> getHome() async {
  // ... implementation
  return Right(homeEntity); // Success
  // or
  return Left(ServerFailure(message: 'Error')); // Failure
}

// Handling the result
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (success) => print('Success: $success'),
);
```

---

## Testing

### Unit Test Example

```dart
void main() {
  group('HomeCubit', () {
    late HomeCubit homeCubit;
    late MockGetHomeUseCase mockGetHomeUseCase;

    setUp(() {
      mockGetHomeUseCase = MockGetHomeUseCase();
      homeCubit = HomeCubit(getHomeUseCase: mockGetHomeUseCase);
    });

    tearDown(() {
      homeCubit.close();
    });

    test('should emit [HomeLoadingState, HomeLoadedState]', () async {
      // Arrange
      when(mockGetHomeUseCase()).thenAnswer(
        (_) async => Right(testHome),
      );

      // Act
      homeCubit.getHome();

      // Assert
      expect(
        homeCubit.stream,
        emitsInOrder([
          HomeLoadingState(),
          HomeLoadedState(home: testHome),
        ]),
      );
    });
  });
}
```

---

## Best Practices

### ✅ DO:
- Keep entities pure Dart classes
- Use use cases to handle business logic
- Inject dependencies via constructors
- Emit appropriate states from cubits
- Handle all error scenarios

### ❌ DON'T:
- Access data layer directly from UI
- Put business logic in widgets
- Use BuildContext across layers
- Hardcode values (use constants instead)
- Ignore error handling

---

## Troubleshooting

### Issue: "Failed to get dependencies"
Solution: Run `flutter pub get` in your project root

### Issue: "Unhandled exception in event loop"
Solution: Ensure all async operations in usecases are properly handled with fold()

### Issue: "Locale not changing"
Solution: Ensure EasyLocalization.ensureInitialized() is called in main()

### Issue: "Cubit not found in context"
Solution: Verify Cubit is registered in BlocProvider in MultiBlocProvider in main.dart
