import '../../domain/entities/currency_rate.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_datasource.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CurrencyRate>> getRates(String currencyCode) async {
    try {
      final rates = await remoteDataSource.getRates(currencyCode);
      rates.sort((a, b) => a.date.compareTo(b.date));
      return rates;
    } catch (e) {
      rethrow;
    }
  }
}