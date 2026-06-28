import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:touch/core/services/secure_storage_service.dart';

/// HTTP Client Service using Dio with interceptor for token management
/// Handles all API requests with automatic token injection
class DioClient {
  final Dio _dio;
  final SecureStorageService _secureStorage;
  static HiveCacheStore? _cacheStore;
  static CacheOptions? _cacheOptions;
  static const String _tokenKey = 'access_token';
  static String _currentLanguage = 'ar'; // Manual language setting
  static String _currentToken = ''; // Current user token from login

  DioClient({
    required Dio dio,
    required SecureStorageService secureStorage,
    String baseUrl = 'https://api.example.com',
  }) : _dio = dio,
       _secureStorage = secureStorage {
    _setupDio(baseUrl);
    _initCacheStore();
  }

  /// Set the current language manually (call when language changes)
  static void setLanguage(String langCode) {
    _currentLanguage = langCode;
  }

  /// Get the current language
  static String getLanguage() {
    return _currentLanguage;
  }

  /// Set the access token (call after successful login)
  static void setToken(String token) {
    _currentToken = token;
  }

  /// Get the current access token
  static String getToken() {
    return _currentToken;
  }

  /// Clear the access token (call on logout)
  static void clearToken() {
    _currentToken = '';
  }

  /// Initialize Dio with base URL and interceptors
  void _setupDio(String baseUrl) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json', "lang": ""},
    );

    // Add pretty logger interceptor
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    );

    // Add interceptor for token management
    _dio.interceptors.add(_TokenInterceptor(_secureStorage));
  }

  static Future<void> _initCacheStore() async {
    if (_cacheStore == null) {
      final dir = await getApplicationDocumentsDirectory();
      _cacheStore = HiveCacheStore('${dir.path}/dio_cache');
      _cacheOptions = CacheOptions(
        store: _cacheStore,
        policy: CachePolicy.noCache, // Default: no caching
        hitCacheOnErrorExcept: [401, 403],
        maxStale: const Duration(days: 7),
      );
    }
  }

  /// Returns CacheOptions to enable caching for a specific request.
  /// Usage: dio.get('/endpoint', options: Options(extra: DioFactory.cacheEnabled));
  static Map<String, dynamic> get cacheEnabled => _cacheOptions != null
      ? _cacheOptions!.copyWith(policy: CachePolicy.forceCache).toExtra()
      : {};

  /// Returns CacheOptions to refresh cache for a specific request (fetch from network and update cache).
  /// Usage: dio.get('/endpoint', options: Options(extra: DioFactory.cacheRefresh));
  static Map<String, dynamic> get cacheRefresh => _cacheOptions != null
      ? _cacheOptions!.copyWith(policy: CachePolicy.refreshForceCache).toExtra()
      : {};

  /// GET request
  Future<Response> get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool enableCache = false,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options?.copyWith(extra: enableCache ? cacheEnabled : null),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// POST request
  Future<Response> post({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool enableCache = false,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options?.copyWith(extra: enableCache ? cacheEnabled : null),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool enableCache = false,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options?.copyWith(extra: enableCache ? cacheEnabled : null),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// PATCH request
  Future<Response> patch({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool enableCache = false,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options?.copyWith(extra: enableCache ? cacheEnabled : null),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool enableCache = false,
  }) async {
    try {
      return await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: options?.copyWith(extra: enableCache ? cacheEnabled : null),
      );
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  /// Set access token
  Future<void> setAccessToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Clear access token
  Future<void> clearAccessToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Handle Dio exceptions and convert to appropriate failures
  void _handleDioError(DioException error) {
    print('🔴 DioClient Error: ${error.message}');
    print('📍 Error Type: ${error.type}');
    print('🌐 Status Code: ${error.response?.statusCode}');
  }
}

/// Interceptor to handle automatic token injection in requests
class _TokenInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  _TokenInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // First check if token was set via setToken() (from current login session)
      String? token = DioClient._currentToken.isNotEmpty
          ? DioClient._currentToken
          : null;

      // Fall back to secure storage if no current token is set
      if (token == null || token.isEmpty) {
        token = await _secureStorage.read(key: 'access_token');
      }

      // Add token to Authorization header if available
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // Add current language header (manually set)
      options.headers['lang'] = DioClient._currentLanguage;

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to add token: $e',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Handle successful responses
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    print('🔴 HTTP Error: ${err.response?.statusCode} - ${err.message}');

    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      print('⚠️ Unauthorized (401) - Token might be expired');
      // You can implement token refresh logic here
      // For now, clear the token and let the app handle re-authentication
      await _secureStorage.delete(key: 'access_token');
    }

    // Handle other error cases as needed
    handler.next(err);
  }
}
