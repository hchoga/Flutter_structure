import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/usecases/usecase.dart';
import 'package:touch/features/login/domain/entities/user.dart';
import 'package:touch/features/login/domain/repositories/login_repository.dart';

class LoginUseCase extends UseCase<User, LoginParams> {
  final LoginRepository repository;

  LoginUseCase({required this.repository});

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      params.email,
      params.password,
      params.loginMethod,
      countryCode: params.countryCode,
    );
  }
}

class LoginParams {
  final String email;
  final String password;
  final String loginMethod; // 'phone', 'email', 'civil_id'
  final String? countryCode; // Country code for phone login

  LoginParams({
    required this.email,
    required this.password,
    this.loginMethod = 'email',
    this.countryCode,
  });
}
