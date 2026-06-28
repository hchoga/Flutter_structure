import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/services/network_info.dart';
import 'package:touch/features/home/data/datasources/home_local_data_source.dart';
import 'package:touch/features/home/data/datasources/home_remote_data_source.dart';
import 'package:touch/features/home/domain/entities/home_entity.dart';
import 'package:touch/features/home/domain/repositories/home_repository.dart';

/// Implementation of HomeRepository
/// Following SOLID principles (Liskov Substitution Principle)
/// This bridges between domain and data layers
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, HomeEntity>> getHome() async {
    try {
      if (await networkInfo.isConnected) {
        final remoteHome = await remoteDataSource.getHome();
        await localDataSource.cacheHome(remoteHome);
        return Right(remoteHome.toEntity());
      } else {
        final localHome = await localDataSource.getLastHome();
        return Right(localHome.toEntity());
      }
    } on Failure catch (failure) {
      // Failure already typed — wrap in Left
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getHomeList() async {
    try {
      if (await networkInfo.isConnected) {
        final remoteList = await remoteDataSource.getHomeList();
        return Right(remoteList.map((model) => model.toEntity()).toList());
      } else {
        return Left(NetworkFailure(message: 'No internet connection'));
      }
    } on Failure catch (failure) {
      // Failure already typed — wrap in Left
      return Left(failure);
    }
  }
}
