import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../features/exchange/data/datasources/currency_remote_datasource.dart';
import '../../features/exchange/data/repositories/currency_repository_impl.dart';
import '../../features/exchange/domain/repositories/currency_repository.dart';
import '../../features/exchange/domain/usecases/get_currency_rates.dart';
import '../../features/exchange/domain/usecases/get_daily_rates.dart';
import '../../features/exchange/presentation/bloc/currency_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Presentation Layer
  _initPresentation();
  
  // Domain Layer
  _initDomain();
  
  // Data Layer
  _initData();
  
  // External Dependencies
  _initExternal();
}

void _initPresentation() {
  // BLoC
  sl.registerFactory(() => CurrencyBloc(
    getCurrencyRates: sl(),
    getDailyRates: sl(),
  ));
}

void _initDomain() {
  // Use Cases
  sl.registerLazySingleton(() => GetCurrencyRates(sl()));
  sl.registerLazySingleton(() => GetDailyRates(sl()));
}

void _initData() {
  // Repositories
  sl.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSourceImpl(dio: sl()),
  );
}

void _initExternal() {
  // HTTP Client
  sl.registerLazySingleton(() => Dio(BaseOptions(
    baseUrl: 'https://api-brl-exchange.actionlabs.com.br/api/1.0',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )));
}