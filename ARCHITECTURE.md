# Clean Architecture Guide

## Overview

This project follows **Clean Architecture** principles combined with **SOLID principles** for maintainable, scalable, and testable code.

## Architecture Layers

### 1. **Presentation Layer** (`features/home/presentation/`)
- **Cubits**: State management using `flutter_bloc`
- **Pages**: Main UI screens
- **Widgets**: Reusable UI components

**SOLID Principles Applied**:
- **Single Responsibility**: Each Cubit handles only one feature's state
- **Open/Closed**: Easy to extend with new pages/widgets without modifying existing ones

### 2. **Domain Layer** (`features/home/domain/`)
- **Entities**: Core business logic models (platform-independent)
- **Repositories**: Abstract interfaces defining contracts
- **Use Cases**: Application business logic

**SOLID Principles Applied**:
- **Dependency Inversion**: Domain depends on abstractions, not concrete implementations
- **Interface Segregation**: Repositories have focused interfaces

### 3. **Data Layer** (`features/home/data/`)
- **Models**: Data models with JSON serialization
- **Data Sources**: Remote (API) and Local (Cache) data access — **organized in separate files**
  - `datasources/remote/`: API calls and network operations
  - `datasources/local/`: Caching and local storage operations
- **Repositories**: Implementation of domain repositories

**SOLID Principles Applied**:
- **Liskov Substitution**: Repository implementations are substitutable for the abstract interface
- **Single Responsibility**: Each data source handles one type of data access (remote or local)

### 4. **Core Layer** (`core/`)
- **Errors**: Exception and Failure classes
- **Constants**: App-wide constants
- **Use Cases**: Base classes for all use cases
- **Network**: Network connectivity abstraction

## Dependency Flow

```
Presentation Layer (UI)
        ↓
Domain Layer (Business Logic)
        ↓
Data Layer (Data Access)
        ↓
Core Layer (Utilities)
```

## Key Components

### State Management (Cubit)
```dart
// States represent the UI state
// Uses method-based state management (no events)

HomeCubit:
- Methods: getHome(), getHomeList()
- States: HomeLoadingState → HomeLoadedState/HomeListLoadedState/HomeErrorState
```

### Navigation (GoRouter)
- Type-safe routes with parameters
- Deep linking support
- Error handling

### Localization (Easy Localization)
- Multi-language support
- JSON-based translations
- Runtime language switching
- Type-safe keys using generated `LocaleKeys`

**Usage Example:**
```dart
import 'package:touch/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

// Use LocaleKeys for type-safe translations
Text(LocaleKeys.home_title.tr())
Text('${LocaleKeys.error.tr()}: ${errorMessage}')
```

**Generate LocaleKeys:**
```bash
dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart && dart run easy_localization:generate --source-dir ./assets/translations
```

### Dependency Injection (GetIt)
- Service Locator pattern
- Easy testing and mocking
- Clear dependency management

### Network Layer
- **DioClient**: HTTP client with Dio, token injection, and pretty logging
- **DioExceptionHandler**: Converts DioException to domain Failures
- **TokenInterceptor**: Automatically injects Bearer tokens in requests

**Error Handling Flow:**
```
DioClient (HTTP Request)
    ↓
DioException (on error)
    ↓
DioExceptionHandler.fromDioException() (converts to Failure)
    ↓
DataSource throws Failure
    ↓
Repository catches & wraps in Either<Failure, Success>
    ↓
Cubit handles with .fold()
    ↓
UI renders error state
```

### DataSource Organization

DataSources are organized into separate files within a flat `datasources/` folder for better maintainability and separation of concerns:

#### Remote DataSource (`datasources/your_remote_data_source.dart`)
- Handles all API calls via DioClient
- Manages network operations
- Converts `DioException` to domain `Failure` classes
- Never performs local storage operations

#### Local DataSource (`datasources/your_local_data_source.dart`) [OPTIONAL]
- Handles caching with FlutterSecureStorage or SharedPreferences
- Manages offline data persistence
- No network operations
- Used as fallback when network is unavailable
- Throws `CacheFailure` for cache-related errors

#### Repository Integration
The repository combines both data sources:
1. **Primary Source**: Try remote data source first
2. **Cache Layer**: Save remote data locally
3. **Fallback**: Use local cache if remote fails
4. **Error Handling**: Wrap all operations in `Either<Failure, Success>`

**Example Directory Structure (Default - Remote Only):**
```
features/user/data/
├── datasources/
│   └── user_remote_data_source.dart
├── models/
│   └── user_model.dart
└── repositories/
    └── user_repository_impl.dart
```

**With Local Caching (Optional):**
```
features/user/data/
├── datasources/
│   ├── user_remote_data_source.dart
│   └── user_local_data_source.dart
├── models/
│   └── user_model.dart
└── repositories/
    └── user_repository_impl.dart
```

### Error Classes (Core Layer)

## How to Add a New Feature

### 1. Create Domain Layer
```
features/newfeature/domain/
├── entities/
│   └── new_entity.dart
├── repositories/
│   └── new_repository.dart
└── usecases/
    └── new_usecases.dart
```

### 2. Create Data Layer
```
features/newfeature/data/
├── datasources/
│   └── new_datasource.dart
├── models/
│   └── new_model.dart
└── repositories/
    └── new_repository_impl.dart
```

### 3. Create Presentation Layer
```
features/newfeature/presentation/
├── cubit/
│   ├── new_cubit.dart
│   └── new_state.dart
├── pages/
│   └── new_page.dart
└── widgets/
    └── new_widget.dart
```

### 4. Register in Service Locator
```dart
// In service_locator.dart
getIt.registerSingleton<NewRepository>(
  NewRepositoryImpl(...),
);
```

### 5. Add Routes
```dart
// In config/routes/app_routes.dart
GoRoute(
  path: '/new-feature',
  builder: (context, state) => const NewPage(),
),
```

## SOLID Principles Breakdown

### Single Responsibility Principle (SRP)
- Each class has one reason to change
- `HomeCubit` only manages home state
- `HomeRepository` only defines data access contracts

### Open/Closed Principle (OCP)
- Open for extension, closed for modification
- Add new features without changing existing ones
- Use abstract classes and interfaces

### Liskov Substitution Principle (LSP)
- Derived classes can substitute base classes
- `HomeRepositoryImpl` can replace `HomeRepository`

### Interface Segregation Principle (ISP)
- Clients depend on specific interfaces
- `HomeLocalDataSource` and `HomeRemoteDataSource` are separate interfaces
- `NetworkInfo` is focused on connectivity checks

### Dependency Inversion Principle (DIP)
- Depend on abstractions, not concretions
- Cubits depend on Use Cases (abstractions)
- Use Cases depend on Repository interfaces
- Implemented via GetIt service locator

## Benefits

✅ **Testability**: Easy to mock dependencies and unit test
✅ **Maintainability**: Clear separation of concerns
✅ **Scalability**: Easy to add new features
✅ **Flexibility**: Easy to change implementations
✅ **Reusability**: Components can be reused across the app
✅ **SOLID Compliance**: Professional code structure

## File Structure Reference

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── localization/
│   │   └── localization_service.dart
│   ├── network/
│   │   └── network_info.dart
│   ├── routes/
│   │   └── app_routes.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── usecases/
│       └── usecase.dart
├── features/
│   └── home/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── cubit/
│           ├── pages/
│           └── widgets/
├── service_locator.dart
└── main.dart
```

## Next Steps

1. Update datasources with actual API/Cache implementation
2. Add more features following this pattern
3. Implement error handling and logging
4. Add unit and widget tests
5. Configure CI/CD pipeline
