import '../entities/currency_rate.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyRate>> getRates(String currencyCode);
}
