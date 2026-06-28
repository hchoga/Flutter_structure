import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/usecases/usecase.dart';
import 'package:touch/features/login/domain/repositories/login_repository.dart';

class LogoutUseCase extends UseCaseNoParams<void> {
  final LoginRepository repository;

  LogoutUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.logout();
  }
}
