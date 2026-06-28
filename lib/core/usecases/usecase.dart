import 'package:dartz/dartz.dart';
import 'package:touch/core/errors/failures.dart';

/// Abstract base class for all use cases in the application.
/// Following SOLID principles (Liskov Substitution Principle and Dependency Inversion Principle)
/// Uses dartz Either to handle success and failure states functionally.

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// UseCase for operations that don't require parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<Failure, Type>> call();
}
