import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/currency_rate.dart';
import '../repositories/currency_repository.dart';

class GetCurrencyRates implements UseCase<List<CurrencyRate>, GetCurrencyRatesParams> {
  final CurrencyRepository repository;

  GetCurrencyRates(this.repository);

  @override
  Future<Either<Failure, List<CurrencyRate>>> call(GetCurrencyRatesParams params) async {
    return await repository.getRates(params.currencyCode);
  }
}

class GetCurrencyRatesParams extends Equatable {
  final String currencyCode;

  const GetCurrencyRatesParams({required this.currencyCode});

  @override
  List<Object?> get props => [currencyCode];
}
