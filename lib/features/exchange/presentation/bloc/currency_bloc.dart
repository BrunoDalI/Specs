import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_currency_rates.dart';
import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencyRates getCurrencyRates;

  CurrencyBloc({required this.getCurrencyRates}) : super(CurrencyInitial()) {
    on<LoadCurrencyRates>(_onLoadCurrencyRates);
  }

  Future<void> _onLoadCurrencyRates(
    LoadCurrencyRates event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(CurrencyLoading());
    
    final params = GetCurrencyRatesParams(currencyCode: event.currencyCode);
    final result = await getCurrencyRates(params);
    
    result.fold(
      (failure) => emit(CurrencyError(failure.message)),
      (rates) => emit(CurrencyLoaded(rates)),
    );
  }
}