import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetCurrencyRatesParams {
  final String currencyCode;
  
  const GetCurrencyRatesParams({required this.currencyCode});
}

class GetCurrencyRates implements UseCase<List<CurrencyRate>, GetCurrencyRatesParams> {
  final CurrencyRepository repository;

  GetCurrencyRates(this.repository);

  @override
  Future<Either<Failure, List<CurrencyRate>>> call(GetCurrencyRatesParams params) async {
    final result = await repository.getRates(params.currencyCode);
    
    return result.fold(
      (failure) => Left(failure),
      (rates) {
        // Calcula a diferença entre as taxas
        final updatedRates = <CurrencyRate>[];
        for (int i = 0; i < rates.length; i++) {
          if (i == 0) {
            updatedRates.add(rates[i]);
          } else {
            updatedRates.add(rates[i].copyWith(
              closeDiff: rates[i].close - rates[i - 1].close,
            ));
          }
        }
        return Right(updatedRates);
      },
    );
  }
}
