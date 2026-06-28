import 'package:dio/dio.dart';
import 'package:touch/core/network/dio_client.dart';
import 'package:touch/core/network/dio_exception_handler.dart';
import 'package:touch/features/home/data/models/home_model.dart';

/// Abstract interface for home remote data source
abstract class HomeRemoteDataSource {
  Future<HomeModel> getHome();
  Future<List<HomeModel>> getHomeList();
}

/// Implementation of HomeRemoteDataSource
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<HomeModel> getHome() async {
    try {
      final response = await dioClient.get(path: '/home');
      return HomeModel.fromJson(response.data);
    } on DioException catch (e) {
      // Convert DioException to Failure and throw
      throw DioExceptionHandler.fromDioException(e);
    }
  }

  @override
  Future<List<HomeModel>> getHomeList() async {
    try {
      final response = await dioClient.get(path: '/homes');
      final List<dynamic> data = response.data;
      return data.map((json) => HomeModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // Convert DioException to Failure and throw
      throw DioExceptionHandler.fromDioException(e);
    }
  }
}
