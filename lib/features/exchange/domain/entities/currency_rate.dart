class CurrencyRate {
  final String date;
  final double close;
  final double? closeDiff;

  CurrencyRate({
    required this.date,
    required this.close,
    this.closeDiff,
  });
}
