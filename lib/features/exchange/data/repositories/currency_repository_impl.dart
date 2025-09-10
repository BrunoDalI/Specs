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
      rates.sort((a, b) => a.date.compareTo(b.date));
      return Right(rates);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure('Unexpected error: ${e.toString()}'));
    }
  }

  Failure _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      case DioExceptionType.badResponse:
        if (exception.response?.statusCode == 429) {
          return const ServerFailure('Rate limit exceeded. Try again later.');
        }
        return ServerFailure('Server error: ${exception.response?.statusCode}');
      default:
        return NetworkFailure('Network error: ${exception.message}');
    }
  }
}