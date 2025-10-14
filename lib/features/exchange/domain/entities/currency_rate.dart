import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String date;
  final double close;
  final double? open;
  final double? high;
  final double? low;
  final double? closeDiff;

  const CurrencyRate({
    required this.date,
    required this.close,
    this.open,
    this.high,
    this.low,
    this.closeDiff,
  });

  @override
  List<Object?> get props => [date, close, open, high, low, closeDiff];

  CurrencyRate copyWith({
    String? date,
    double? close,
    double? open,
    double? high,
    double? low,
    double? closeDiff,
  }) {
    return CurrencyRate(
      date: date ?? this.date,
      close: close ?? this.close,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      closeDiff: closeDiff ?? this.closeDiff,
    );
  }
}
