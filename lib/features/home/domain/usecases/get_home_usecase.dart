import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/usecases/usecase.dart';
import 'package:touch/features/home/domain/entities/home_entity.dart';
import 'package:touch/features/home/domain/repositories/home_repository.dart';

/// Get Home Use Case
/// Following SOLID principles (Single Responsibility Principle)
class GetHomeUseCase extends UseCaseNoParams<HomeEntity> {
  final HomeRepository repository;

  GetHomeUseCase({required this.repository});

  @override
  Future<Either<Failure, HomeEntity>> call() async {
    return await repository.getHome();
  }
}
