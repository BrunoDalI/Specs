import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetDailyRatesParams extends Equatable {
  final String currencyCode;

  const GetDailyRatesParams({required this.currencyCode});

  @override
  List<Object?> get props => [currencyCode];
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
        final processedRates = _calculateCloseDiff(rates);
        return Right(processedRates);
      },
    );
  }

  List<CurrencyRate> _calculateCloseDiff(List<CurrencyRate> rates) {
    if (rates.isEmpty) return rates;
    
    final sortedRates = List<CurrencyRate>.from(rates)
      ..sort((a, b) => a.date.compareTo(b.date));
    
    for (int i = 1; i < sortedRates.length; i++) {
      final currentRate = sortedRates[i];
      final previousRate = sortedRates[i - 1];
      
      sortedRates[i] = currentRate.copyWith(
        closeDiff: currentRate.close - previousRate.close,
      );
    }
    
    return sortedRates.reversed.toList();
  }
}
