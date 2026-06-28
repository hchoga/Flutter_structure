import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/features/login/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> login(
    String email,
    String password,
    String loginMethod, {
    String? countryCode,
  });
  Future<Either<Failure, void>> logout();
}
