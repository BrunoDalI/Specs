import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetDailyRatesParams {
  final String currencyCode;
  
  const GetDailyRatesParams({required this.currencyCode});
}

class GetDailyRates implements UseCase<List<CurrencyRate>, GetDailyRatesParams> {
  final CurrencyRepository repository;

  GetDailyRates(this.repository);

  @override
  Future<Either<Failure, List<CurrencyRate>>> call(GetDailyRatesParams params) async {
    final result = await repository.getDailyRates(params.currencyCode);
    
    return result.fold(
      (failure) => Left(failure),
      (rates) {
        final updatedRates = <CurrencyRate>[];
        for (int i = 0; i < rates.length; i++) {
          if (i == rates.length - 1) {
            updatedRates.add(rates[i]);
          } else {
            updatedRates.add(rates[i].copyWith(
              closeDiff: rates[i].close - rates[i + 1].close,
            ));
          }
        }
        return Right(updatedRates);
      },
    );
  }
}
