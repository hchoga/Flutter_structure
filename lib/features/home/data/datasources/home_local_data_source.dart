import 'dart:convert';

import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/services/secure_storage_service.dart';
import 'package:touch/features/home/data/models/home_model.dart';

/// Abstract interface for home local data source
/// Following SOLID principles (Interface Segregation Principle)
abstract class HomeLocalDataSource {
  Future<HomeModel> getLastHome();
  Future<void> cacheHome(HomeModel homeModel);
  Future<void> clearCache();
}

/// Implementation of HomeLocalDataSource
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final SecureStorageService secureStorage;
  static const _homeCacheKey = 'cached_home';

  HomeLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<HomeModel> getLastHome() async {
    try {
      final cachedData = await secureStorage.read(key: _homeCacheKey);
      if (cachedData == null) {
        throw CacheFailure(message: 'No cached home found');
      }
      return HomeModel.fromJson(jsonDecode(cachedData));
    } catch (e) {
      if (e is CacheFailure) rethrow;
      throw CacheFailure(message: 'Failed to retrieve cached home: $e');
    }
  }

  @override
  Future<void> cacheHome(HomeModel homeModel) async {
    try {
      await secureStorage.write(
        key: _homeCacheKey,
        value: jsonEncode(homeModel.toJson()),
      );
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache home: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: _homeCacheKey);
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache: $e');
    }
  }
}
