import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/currency_rate.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, List<CurrencyRate>>> getRates(String currencyCode);
  Future<Either<Failure, List<CurrencyRate>>> getDailyRates(String currencyCode);
}
