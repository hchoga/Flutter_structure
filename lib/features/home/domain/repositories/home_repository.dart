import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';
import 'package:touch/features/home/domain/entities/home_entity.dart';

/// Abstract repository interface for home feature
/// Following SOLID principles (Dependency Inversion Principle)
/// This defines the contract that the data layer must implement
abstract class HomeRepository {
  Future<Either<Failure, HomeEntity>> getHome();
  Future<Either<Failure, List<HomeEntity>>> getHomeList();
}
