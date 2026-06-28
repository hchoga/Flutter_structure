import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:touch/core/network/dio_client.dart';
import 'package:touch/core/services/connectivity_service.dart';
import 'package:touch/core/services/dialog_service.dart';
import 'package:touch/core/services/network_info.dart';
import 'package:touch/core/services/secure_storage_service.dart';
import 'package:touch/features/home/data/datasources/home_local_data_source.dart';
import 'package:touch/features/home/data/datasources/home_remote_data_source.dart';
import 'package:touch/features/home/data/repositories/home_repository_impl.dart';
import 'package:touch/features/home/domain/repositories/home_repository.dart';
import 'package:touch/features/home/domain/usecases/get_home_list_usecase.dart';
import 'package:touch/features/home/domain/usecases/get_home_usecase.dart';
import 'package:touch/features/home/presentation/cubit/home_cubit.dart';
import 'package:touch/features/login/data/datasources/login_local_data_source.dart';
import 'package:touch/features/login/data/datasources/login_remote_data_source.dart';
import 'package:touch/features/login/data/repositories/login_repository_impl.dart';
import 'package:touch/features/login/domain/repositories/login_repository.dart';
import 'package:touch/features/login/domain/usecases/login_usecase.dart';
import 'package:touch/features/login/domain/usecases/logout_usecase.dart';
import 'package:touch/features/login/presentation/cubit/login_cubit.dart';

final sl = GetIt.instance;

/// Service Locator Setup
/// Following SOLID principles (Dependency Inversion Principle)
/// All dependencies are registered here for easy management and testing
void setupServiceLocator() {
  // ==================== Core Services ====================
  sl.registerSingleton<ConnectivityService>(ConnectivityService());
  sl.registerSingleton<NetworkInfo>(NetworkInfoImpl());
  sl.registerSingleton<DialogService>(DialogService());
  // sl.registerSingleton<ShowToast>(ShowToast());
  sl.registerSingletonAsync<SecureStorageService>(
    () => SecureStorageServiceImpl.create(),
  );

  // Register DioClient with Dio instance (async to wait for SecureStorageService)
  sl.registerSingletonAsync<DioClient>(() async {
    final secureStorage = await sl.getAsync<SecureStorageService>();
    return DioClient(
      dio: Dio(),
      secureStorage: secureStorage,
      baseUrl: 'https://erp-hr.testdomain100.online/api',
    );
  });

  // ==================== Home Feature ====================
  // Data sources
  sl.registerSingletonAsync<HomeLocalDataSource>(() async {
    final secureStorage = await sl.getAsync<SecureStorageService>();
    return HomeLocalDataSourceImpl(secureStorage: secureStorage);
  });
  sl.registerSingletonAsync<HomeRemoteDataSource>(() async {
    final dioClient = await sl.getAsync<DioClient>();
    return HomeRemoteDataSourceImpl(dioClient: dioClient);
  });

  // Repositories
  sl.registerSingletonAsync<HomeRepository>(() async {
    final remoteDataSource = await sl.getAsync<HomeRemoteDataSource>();
    final localDataSource = sl<HomeLocalDataSource>();
    final networkInfo = sl<NetworkInfo>();
    return HomeRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  // Use cases
  sl.registerSingletonAsync<GetHomeUseCase>(() async {
    final repository = await sl.getAsync<HomeRepository>();
    return GetHomeUseCase(repository: repository);
  });
  sl.registerSingletonAsync<GetHomeListUseCase>(() async {
    final repository = await sl.getAsync<HomeRepository>();
    return GetHomeListUseCase(repository: repository);
  });

  // Cubits
  sl.registerSingletonAsync<HomeCubit>(() async {
    final getHomeUseCase = await sl.getAsync<GetHomeUseCase>();
    final getHomeListUseCase = await sl.getAsync<GetHomeListUseCase>();
    return HomeCubit(
      getHomeUseCase: getHomeUseCase,
      getHomeListUseCase: getHomeListUseCase,
    );
  });

  // ==================== Login Feature ====================
  // Data sources
  sl.registerSingletonAsync<LoginLocalDataSource>(() async {
    final secureStorage = await sl.getAsync<SecureStorageService>();
    return LoginLocalDataSourceImpl(secureStorage: secureStorage);
  });
  sl.registerSingletonAsync<LoginRemoteDataSource>(() async {
    final dioClient = await sl.getAsync<DioClient>();
    return LoginRemoteDataSourceImpl(dioClient: dioClient);
  });

  // Repositories
  sl.registerSingletonAsync<LoginRepository>(() async {
    final remoteDataSource = await sl.getAsync<LoginRemoteDataSource>();
    final localDataSource = await sl.getAsync<LoginLocalDataSource>();
    return LoginRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  // Use cases
  sl.registerSingletonAsync<LoginUseCase>(() async {
    final repository = await sl.getAsync<LoginRepository>();
    return LoginUseCase(repository: repository);
  });
  sl.registerSingletonAsync<LogoutUseCase>(() async {
    final repository = await sl.getAsync<LoginRepository>();
    return LogoutUseCase(repository: repository);
  });

  // Cubits
  sl.registerSingletonAsync<LoginCubit>(() async {
    final loginUseCase = await sl.getAsync<LoginUseCase>();
    final logoutUseCase = await sl.getAsync<LogoutUseCase>();
    return LoginCubit(loginUseCase: loginUseCase, logoutUseCase: logoutUseCase);
  });

  // ==================== Forgot Password Feature ====================

}
