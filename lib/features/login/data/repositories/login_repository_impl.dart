import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/features/login/data/datasources/login_local_data_source.dart';
import 'package:touch/features/login/data/datasources/login_remote_data_source.dart';
import 'package:touch/features/login/domain/entities/user.dart';
import 'package:touch/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final LoginLocalDataSource localDataSource;

  LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login(
    String email,
    String password,
    String loginMethod, {
    String? countryCode,
  }) async {
    try {
      final userModel = await remoteDataSource.login(
        email,
        password,
        loginMethod,
        countryCode,
      );
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } on ServerFailure catch (e) {
      return Left(e); // passes ServerFailure directly, type is preserved
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();

      await remoteDataSource.logout();

      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(
          message: "Ops, seems like there is no internet connection.",
        ),
      );
    }
  }
}
