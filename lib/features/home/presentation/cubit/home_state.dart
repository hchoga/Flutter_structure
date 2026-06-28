import 'package:touch/features/home/domain/entities/home_entity.dart';

/// Base state for Home Cubit
/// Using sealed class for type-safe exhaustive checking
/// Following SOLID principles (Single Responsibility Principle)
sealed class HomeState {}

/// Initial state when HomeCubit is created
class HomeInitialState extends HomeState {}

/// Loading state while fetching data
class HomeLoadingState extends HomeState {}

/// State when a single home entity is successfully loaded
class HomeLoadedState extends HomeState {
  final HomeEntity home;

  HomeLoadedState({required this.home});
}

/// State when a list of home entities is successfully loaded
class HomeListLoadedState extends HomeState {
  final List<HomeEntity> homeList;

  HomeListLoadedState({required this.homeList});
}

/// Error state when an operation fails
class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});
}
