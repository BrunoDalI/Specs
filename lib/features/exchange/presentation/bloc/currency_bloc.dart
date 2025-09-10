import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_currency_rates.dart';
import '../../domain/usecases/get_daily_rates.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencyRates getCurrencyRates;
  final GetDailyRates getDailyRates;

  CurrencyBloc({
    required this.getCurrencyRates,
    required this.getDailyRates,
  }) : super(const CurrencyInitial()) {
    on<LoadCurrencyRates>(_onLoadCurrencyRates);
    on<LoadDailyRates>(_onLoadDailyRates);
  }

  Future<void> _onLoadCurrencyRates(
    LoadCurrencyRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());
    
    final params = GetCurrencyRatesParams(currencyCode: event.currencyCode);
    final result = await getCurrencyRates(params);
    
    result.fold(
      (failure) => emit(CurrencyError(failure.message)),
      (rates) => emit(CurrencyLoaded(rates)),
    );
  }

  Future<void> _onLoadDailyRates(
    LoadDailyRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const DailyRatesLoading());
    
    final params = GetDailyRatesParams(currencyCode: event.currencyCode);
    final result = await getDailyRates(params);
    
    result.fold(
      (failure) => emit(CurrencyError(failure.message, isDaily: true)),
      (rates) => emit(DailyRatesLoaded(rates)),
    );
  }
}