import 'package:equatable/equatable.dart';

class CurrencyRate extends Equatable {
  final String date;
  final double close;
  final double? closeDiff;

  const CurrencyRate({
    required this.date,
    required this.close,
    this.closeDiff,
  });

  @override
  List<Object?> get props => [date, close, closeDiff];

  CurrencyRate copyWith({
    String? date,
    double? close,
    double? closeDiff,
  }) {
    return CurrencyRate(
      date: date ?? this.date,
      close: close ?? this.close,
      closeDiff: closeDiff ?? this.closeDiff,
    );
  }
}
