import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
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
      (failure) {
        if (failure is ServerFailure) {
          emit(const CurrencyError('Server error. Please try again later.'));
        } else if (failure is ConnectionFailure) {
          emit(const CurrencyError('Connection error. Please check your internet.'));
        } else if (failure is NetworkFailure) {
          emit(const CurrencyError('Network error. Please check your connection.'));
        } else {
          emit(const CurrencyError('An unexpected error occurred.'));
        }
      },
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
      (failure) {
        if (failure is ServerFailure) {
          emit(const CurrencyError('Server error. Please try again later.', isDaily: true));
        } else if (failure is ConnectionFailure) {
          emit(const CurrencyError('Connection error. Please check your internet.', isDaily: true));
        } else if (failure is NetworkFailure) {
          emit(const CurrencyError('Network error. Please check your connection.', isDaily: true));
        } else {
          emit(const CurrencyError('An unexpected error occurred.', isDaily: true));
        }
      },
      (rates) => emit(DailyRatesLoaded(rates)),
    );
  }
}