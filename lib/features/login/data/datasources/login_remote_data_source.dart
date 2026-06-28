import 'package:dio/dio.dart';
import 'package:touch/core/network/dio_client.dart';
import 'package:touch/core/network/dio_exception_handler.dart';
import 'package:touch/features/login/data/models/user_model.dart';

abstract class LoginRemoteDataSource {
  Future<UserModel> login(
    String identifier,
    String password,
    String loginMethod, [
    String? countryCode,
  ]);
  Future<void> logout();
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final DioClient dioClient;

  LoginRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> login(
    String identifier,
    String password,
    String loginMethod, [
    String? countryCode,
  ]) async {
    try {
      final requestData = _buildLoginRequest(
        identifier,
        password,
        loginMethod,
        countryCode,
      );
      final response = await dioClient.post(
        path: '/dashboard-login',
        data: requestData,
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }

  Map<String, dynamic> _buildLoginRequest(
    String identifier,
    String password,
    String loginMethod,
    String? countryCode,
  ) {
    switch (loginMethod) {
      case 'phone':
        return {
          'email_or_phone': identifier,
          'password': password,
          if (countryCode != null) 'country_code': countryCode,
        };
      case 'civil_id':
        return {'national_id': identifier, 'password': password};
      case 'email':
      default:
        return {'email_or_phone': identifier, 'password': password};
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dioClient.post(path: '/auth/logout');
    } on DioException catch (e) {
      throw DioExceptionHandler.fromDioException(e);
    }
  }
}
