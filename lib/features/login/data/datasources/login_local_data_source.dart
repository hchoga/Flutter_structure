import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/services/secure_storage_service.dart';
import 'package:touch/features/login/data/models/user_model.dart';
import 'package:touch/generated/locale_keys.g.dart';

abstract class LoginLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  final SecureStorageService secureStorage;
  static const _userCacheKey = 'cached_login_user';

  LoginLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await secureStorage.write(
        key: _userCacheKey,
        value: jsonEncode(user.toJson()),
      );
    } catch (e) {
      throw CacheFailure(
        message: LocaleKeys.login_cache_error_save.tr(args: ['$e']),
      );
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final cachedData = await secureStorage.read(key: _userCacheKey);
      if (cachedData == null) {
        return null;
      }
      return UserModel.fromJson(jsonDecode(cachedData));
    } catch (e) {
      throw CacheFailure(
        message: LocaleKeys.login_cache_error_read.tr(args: ['$e']),
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await secureStorage.delete(key: _userCacheKey);
    } catch (e) {
      throw CacheFailure(
        message: LocaleKeys.login_cache_error_clear.tr(args: ['$e']),
      );
    }
  }
}
