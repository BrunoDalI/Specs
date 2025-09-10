import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String date;
  final double close;
  final double? closeDiff;
  final double? open;
  final double? high;
  final double? low;

  const CurrencyRate({
    required this.date,
    required this.close,
    this.closeDiff,
    this.open,
    this.high,
    this.low,
  });

  @override
  List<Object?> get props => [date, close, closeDiff, open, high, low];

  CurrencyRate copyWith({
    String? date,
    double? close,
    double? closeDiff,
    double? open,
    double? high,
    double? low,
  }) {
    return CurrencyRate(
      date: date ?? this.date,
      close: close ?? this.close,
      closeDiff: closeDiff ?? this.closeDiff,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
    );
  }
}
