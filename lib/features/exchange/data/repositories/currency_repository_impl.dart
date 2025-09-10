import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/currency_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CurrencyRate>>> getRates(String currencyCode) async {
    try {
      final rates = await remoteDataSource.getRates(currencyCode);
      return Right(rates);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CurrencyRate>>> getDailyRates(String currencyCode) async {
    try {
      final rates = await remoteDataSource.getDailyRates(currencyCode);
      return Right(rates);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionFailure('Timeout de conexão. Verifique sua internet.');
      case DioExceptionType.connectionError:
        return const ConnectionFailure('Erro de conexão. Verifique sua internet.');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 429) {
          return const ServerFailure('Limite de requisições excedido. Tente novamente mais tarde.');
        }
        if (e.response?.statusCode == 500) {
          return const ServerFailure('Erro interno do servidor. Tente novamente mais tarde.');
        }
        return ServerFailure('Erro do servidor: ${e.response?.statusCode}');
      default:
        return NetworkFailure(e.message ?? 'Erro de rede desconhecido');
    }
  }
}