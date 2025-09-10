import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetCurrencyRates {
  final CurrencyRepository repository;

  GetCurrencyRates(this.repository);

  Future<List<CurrencyRate>> call(String currencyCode) async {
    final rates = await repository.getRates(currencyCode);
    for (int i = 1; i < rates.length; i++) {
      rates[i] = CurrencyRate(
        date: rates[i].date,
        close: rates[i].close,
        closeDiff: rates[i].close - rates[i - 1].close,
      );
    }
    return rates;
  }
}
