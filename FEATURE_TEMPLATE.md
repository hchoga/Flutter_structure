# New Feature Template

This is a template for creating new features following the clean architecture pattern.

## 1. Create Entity
**File**: `lib/features/yourfeature/domain/entities/your_entity.dart`

```dart
class YourEntity {
  final int id;
  final String name;

  const YourEntity({
    required this.id,
    required this.name,
  });
}
```

## 2. Create Repository Interface
**File**: `lib/features/yourfeature/domain/repositories/your_repository.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';

abstract class YourRepository {
  Future<Either<Failure, YourEntity>> getYourData();
}
```

## 3. Create Use Cases

### Use Case 1
**File**: `lib/features/yourfeature/domain/usecases/get_your_data_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/usecases/usecase.dart';
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';
import 'package:touch/features/yourfeature/domain/repositories/your_repository.dart';

class GetYourDataUseCase extends UseCaseNoParams<YourEntity> {
  final YourRepository repository;

  GetYourDataUseCase({required this.repository});

  @override
  Future<Either<Failure, YourEntity>> call() async {
    return await repository.getYourData();
  }
}
```

### Use Case 2 (Optional)
**File**: `lib/features/yourfeature/domain/usecases/get_your_data_list_usecase.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/usecases/usecase.dart';
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';
import 'package:touch/features/yourfeature/domain/repositories/your_repository.dart';

class GetYourDataListUseCase extends UseCaseNoParams<List<YourEntity>> {
  final YourRepository repository;

  GetYourDataListUseCase({required this.repository});

  @override
  Future<Either<Failure, List<YourEntity>>> call() async {
    return await repository.getYourDataList();
  }
}
```

## 4. Create Model
**File**: `lib/features/yourfeature/data/models/your_model.dart`

```dart
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';

class YourModel extends YourEntity {
  const YourModel({
    required super.id,
    required super.name,
  });

  factory YourModel.fromJson(Map<String, dynamic> json) {
    return YourModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  YourEntity toEntity() {
    return YourEntity(
      id: id,
      name: name,
    );
  }
}
```

## 5. Create Data Sources (Remote Required, Local Optional)

**Default File Structure (Remote Only):**
```
lib/features/yourfeature/data/datasources/
└── your_remote_data_source.dart
```

**With Local Caching (Optional - Add Only If Needed):**
```
lib/features/yourfeature/data/datasources/
├── your_remote_data_source.dart
└── your_local_data_source.dart
```

### Remote DataSource

**File**: `lib/features/yourfeature/data/datasources/your_remote_data_source.dart`

```dart
import 'package:dio/dio.dart';
import 'package:touch/core/network/dio_exception_handler.dart';
import 'package:touch/core/network/dio_client.dart';
import 'package:touch/features/yourfeature/data/models/your_model.dart';

// Abstract interface
abstract class YourRemoteDataSource {
  Future<YourModel> getYourData();
  Future<YourModel> createYourData(YourModel data);
}

// Implementation
class YourRemoteDataSourceImpl implements YourRemoteDataSource {
  final DioClient dioClient;

  YourRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<YourModel> getYourData() async {
    try {
      final response = await dioClient.get(path: '/your-endpoint');
      return YourModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }

  @override
  Future<YourModel> createYourData(YourModel data) async {
    try {
      final response = await dioClient.post(
        path: '/your-endpoint',
        data: data.toJson(),
      );
      return YourModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }
}
```

### Local DataSource

**File**: `lib/features/yourfeature/data/datasources/your_local_data_source.dart`

```dart
import 'dart:convert';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/services/secure_storage_service.dart';
import 'package:touch/features/yourfeature/data/models/your_model.dart';

// Abstract interface
abstract class YourLocalDataSource {
  Future<YourModel> getCachedData();
  Future<void> cacheData(YourModel model);
  Future<void> clearCache();
}

// Implementation
class YourLocalDataSourceImpl implements YourLocalDataSource {
  final SecureStorageService secureStorage;
  static const _cacheKey = 'cached_your_data';

  YourLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<YourModel> getCachedData() async {
    try {
      final cachedData = await secureStorage.read(key: _cacheKey);
      if (cachedData == null) {
        throw CacheFailure(message: 'No cached data found');
      }
      return YourModel.fromJson(jsonDecode(cachedData));
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure(message: 'Failed to retrieve cached data: $e');
    }
  }

  @override
  Future<void> cacheData(YourModel model) async {
    try {
      await secureStorage.write(
        key: _cacheKey,
        value: jsonEncode(model.toJson()),
      );
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache data: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: _cacheKey);
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: $e');
    }
  }
}
```

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: _cacheKey);
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: $e');
    }
  }
}
```

## 6. Create Repository Implementation
**File**: `lib/features/yourfeature/data/repositories/your_repository_impl.dart`

```dart
import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/features/yourfeature/data/datasources/your_remote_data_source.dart';
import 'package:touch/features/yourfeature/data/datasources/your_local_data_source.dart';
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';
import 'package:touch/features/yourfeature/domain/repositories/your_repository.dart';

class YourRepositoryImpl implements YourRepository {
  final YourRemoteDataSource remoteDataSource;
  final YourLocalDataSource localDataSource;

  YourRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, YourEntity>> getYourData() async {
    try {
      // Try to fetch from remote first
      final remoteData = await remoteDataSource.getYourData();
      
      // Cache locally for offline access
      await localDataSource.cacheData(remoteData);
      
      return Right(remoteData.toEntity());
    } on Failure catch (failure) {
      // If remote fails, try to get from local cache
      try {
        final cachedData = await localDataSource.getCachedData();
        return Right(cachedData.toEntity());
      } catch (_) {
        // Both remote and local failed
        return Left(failure);
      }
    }
  }
}
```

## 7. Create Cubit
**File**: `lib/features/yourfeature/presentation/cubit/your_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';
import 'package:touch/features/yourfeature/domain/usecases/your_usecases.dart';

abstract class YourEvent {}
class GetYourDataEvent extends YourEvent {}

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

class YourCubit extends Cubit<YourState> {
  final GetYourDataUseCase getYourDataUseCase;

  YourCubit({required this.getYourDataUseCase}) : super(YourInitialState());

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

## 8. Create Page
**File**: `lib/features/yourfeature/presentation/pages/your_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch/features/yourfeature/presentation/cubit/your_cubit.dart';

class YourPage extends StatefulWidget {
  const YourPage({super.key});

  @override
  State<YourPage> createState() => _YourPageState();
}

class _YourPageState extends State<YourPage> {
  @override
  void initState() {
    super.initState();
    context.read<YourCubit>().getYourData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Feature')),
      body: BlocBuilder<YourCubit, YourState>(
        builder: (context, state) {
          if (state is YourLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YourLoadedState) {
            return Center(child: Text(state.data.name));
          } else if (state is YourErrorState) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No data'));
        },
      ),
    );
  }
}
```

## 9. Create Widgets
**File**: `lib/features/yourfeature/presentation/widgets/your_widget.dart`

```dart
import 'package:flutter/material.dart';
import 'package:touch/features/yourfeature/domain/entities/your_entity.dart';

class YourWidget extends StatelessWidget {
  final YourEntity data;
  final VoidCallback onTap;

  const YourWidget({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(data.name),
        ),
      ),
    );
  }
}
```

## 10. Register in Service Locator
**File**: `lib/service_locator.dart`

```dart
// Add to setupServiceLocator() function:

// Data sources
getIt.registerSingleton<YourRemoteDataSource>(YourRemoteDataSourceImpl());
getIt.registerSingleton<YourLocalDataSource>(YourLocalDataSourceImpl());

// Repository
getIt.registerSingleton<YourRepository>(
  YourRepositoryImpl(
    remoteDataSource: getIt<YourRemoteDataSource>(),
    localDataSource: getIt<YourLocalDataSource>(),
    networkInfo: getIt<NetworkInfo>(),
  ),
);

// Use case
getIt.registerSingleton<GetYourDataUseCase>(
  GetYourDataUseCase(repository: getIt<YourRepository>()),
);

// Cubit
getIt.registerSingleton<YourCubit>(
  YourCubit(getYourDataUseCase: getIt<GetYourDataUseCase>()),
);
```

## 11. Add to Main.dart
**File**: `lib/main.dart`

```dart
// In MultiBlocProvider:
BlocProvider<YourCubit>(
  create: (context) => getIt<YourCubit>(),
),
```

## 12. Add Route
**File**: `lib/core/routes/app_routes.dart`

```dart
GoRoute(
  path: '/your-feature',
  builder: (context, state) => const YourPage(),
),
```

## 13. Add Translations
Update `assets/translations/en.json` and `assets/translations/ar.json`:

```json
{
  "your_feature": "Your Feature Name",
  "your_data": "Your Data"
}
```

---

## Summary

Follow these steps in order when adding a new feature:
1. ✅ Entity
2. ✅ Repository Interface
3. ✅ Use Cases
4. ✅ Model
5. ✅ Data Sources
6. ✅ Repository Implementation
7. ✅ Cubit
8. ✅ Page
9. ✅ Widgets
10. ✅ Service Locator
11. ✅ Main.dart
12. ✅ Routes
13. ✅ Translations

This ensures consistency and adherence to clean architecture throughout your application.
