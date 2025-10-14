import 'package:equatable/equatable.dart';
import '../../domain/entities/currency_rate.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();
  
  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {
  const CurrencyInitial();
}

class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();
}

class CurrencyLoaded extends CurrencyState {
  final List<CurrencyRate> rates;
  
  const CurrencyLoaded(this.rates);
  
  @override
  List<Object?> get props => [rates];
}

class CurrencyError extends CurrencyState {
  final String message;
  final bool isDaily;
  
  const CurrencyError(this.message, {this.isDaily = false});
  
  @override
  List<Object?> get props => [message, isDaily];
}

class DailyRatesInitial extends CurrencyState {
  const DailyRatesInitial();
}

class DailyRatesLoading extends CurrencyState {
  const DailyRatesLoading();
}

class DailyRatesLoaded extends CurrencyState {
  final List<CurrencyRate> rates;
  
  const DailyRatesLoaded(this.rates);
  
  @override
  List<Object?> get props => [rates];
}