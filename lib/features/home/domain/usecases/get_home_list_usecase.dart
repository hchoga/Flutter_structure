import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/core/usecases/usecase.dart';
import 'package:touch/features/home/domain/entities/home_entity.dart';
import 'package:touch/features/home/domain/repositories/home_repository.dart';

/// Get Home List Use Case
/// Following SOLID principles (Single Responsibility Principle)
class GetHomeListUseCase extends UseCaseNoParams<List<HomeEntity>> {
  final HomeRepository repository;

  GetHomeListUseCase({required this.repository});

  @override
  Future<Either<Failure, List<HomeEntity>>> call() async {
    return await repository.getHomeList();
  }
}
