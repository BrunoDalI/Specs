import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_currency_rates.dart';
import '../../domain/usecases/get_daily_rates.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencyRates getCurrencyRates;
  final GetDailyRates getDailyRates;

  CurrencyState currentRatesState = CurrencyInitial();
  CurrencyState dailyRatesState = DailyRatesInitial();

  CurrencyBloc({
    required this.getCurrencyRates,
    required this.getDailyRates,
  }) : super(CurrencyInitial()) {
    on<LoadCurrencyRates>(_onLoadCurrencyRates);
    on<LoadDailyRates>(_onLoadDailyRates);
  }

  Future<void> _onLoadCurrencyRates(
    LoadCurrencyRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    
    final params = GetCurrencyRatesParams(currencyCode: event.currencyCode);
    final result = await getCurrencyRates(params);
    
    result.fold(
      (failure) {
        currentRatesState = CurrencyError(failure.message);
        emit(currentRatesState);
      },
      (rates) {
        currentRatesState = CurrencyLoaded(rates);
        emit(currentRatesState);
      },
    );
  }

  Future<void> _onLoadDailyRates(
    LoadDailyRates event,
    Emitter<CurrencyState> emit,
  ) async {
    if (currentRatesState is CurrencyLoaded) {
      dailyRatesState = DailyRatesLoading();
      emit(dailyRatesState);
    } else {
      emit(DailyRatesLoading());
    }
    
    final params = GetDailyRatesParams(currencyCode: event.currencyCode);
    final result = await getDailyRates(params);
    
    result.fold(
      (failure) {
        dailyRatesState = CurrencyError(failure.message, isDaily: true);
        emit(dailyRatesState);
      },
      (rates) {
        dailyRatesState = DailyRatesLoaded(rates);
        emit(dailyRatesState);
      },
    );
  }
}