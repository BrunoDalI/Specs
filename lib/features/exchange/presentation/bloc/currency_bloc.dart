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
    try {
      final rates = await getCurrencyRates(event.currencyCode);
      emit(CurrencyLoaded(rates));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }
}