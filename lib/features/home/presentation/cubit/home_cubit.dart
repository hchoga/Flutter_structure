import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:touch/features/home/domain/usecases/get_home_list_usecase.dart';
import 'package:touch/features/home/domain/usecases/get_home_usecase.dart';
import 'package:touch/features/home/presentation/cubit/home_state.dart';

/// Home Cubit for managing home feature state
/// Following SOLID principles (Single Responsibility Principle)
/// Uses states only (no events) for direct method-based state management
class HomeCubit extends Cubit<HomeState> {
  final GetHomeUseCase getHomeUseCase;
  final GetHomeListUseCase getHomeListUseCase;

  HomeCubit({required this.getHomeUseCase, required this.getHomeListUseCase})
    : super(HomeInitialState());

  Future<void> getHome() async {
    emit(HomeLoadingState());
    final result = await getHomeUseCase();

    result.fold(
      (failure) => emit(HomeErrorState(message: failure.message)),
      (home) => emit(HomeLoadedState(home: home)),
    );
  }

  Future<void> getHomeList() async {
    emit(HomeLoadingState());
    final result = await getHomeListUseCase();

    result.fold(
      (failure) => emit(HomeErrorState(message: failure.message)),
      (homeList) => emit(HomeListLoadedState(homeList: homeList)),
    );
  }
}
