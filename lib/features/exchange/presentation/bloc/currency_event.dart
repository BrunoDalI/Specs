import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadCurrencyRates extends CurrencyEvent {
  final String currencyCode;
  
  const LoadCurrencyRates({required this.currencyCode});
  
  @override
  List<Object?> get props => [currencyCode];
}

class LoadDailyRates extends CurrencyEvent {
  final String currencyCode;
  
  const LoadDailyRates({required this.currencyCode});
  
  @override
  List<Object?> get props => [currencyCode];
}