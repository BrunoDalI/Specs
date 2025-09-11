import 'package:flutter_test/flutter_test.dart';
import 'package:specs/features/exchange/domain/entities/currency_rate.dart';

void main() {
  group('CurrencyRate', () {
    const tCurrencyRate = CurrencyRate(
      date: '2025-09-10',
      close: 5.4317,
      open: 5.4197,
      high: 5.4429,
      low: 5.4128,
      closeDiff: 0.12,
    );

    test('should be a subclass of Equatable', () {
      // Assert
      expect(tCurrencyRate, isA<CurrencyRate>());
    });

    test('should return correct props for Equatable', () {
      // Act
      final props = tCurrencyRate.props;
      
      // Assert
      expect(props, [
        '2025-09-10',
        5.4317,
        5.4197,
        5.4429,
        5.4128,
        0.12,
      ]);
    });

    test('should create a copy with updated values', () {
      // Act
      final copiedRate = tCurrencyRate.copyWith(
        close: 5.5000,
        closeDiff: 0.08,
      );
      
      // Assert
      expect(copiedRate.date, '2025-09-10');
      expect(copiedRate.close, 5.5000);
      expect(copiedRate.open, 5.4197);
      expect(copiedRate.high, 5.4429);
      expect(copiedRate.low, 5.4128);
      expect(copiedRate.closeDiff, 0.08);
    });

    test('should maintain original values when copying without changes', () {
      // Act
      final copiedRate = tCurrencyRate.copyWith();
      
      // Assert
      expect(copiedRate, equals(tCurrencyRate));
    });

    test('should be equal when all properties are the same', () {
      // Arrange
      const anotherRate = CurrencyRate(
        date: '2025-09-10',
        close: 5.4317,
        open: 5.4197,
        high: 5.4429,
        low: 5.4128,
        closeDiff: 0.12,
      );
      
      // Assert
      expect(tCurrencyRate, equals(anotherRate));
    });

    test('should not be equal when properties differ', () {
      // Arrange
      const differentRate = CurrencyRate(
        date: '2025-09-11',
        close: 5.4317,
        open: 5.4197,
        high: 5.4429,
        low: 5.4128,
        closeDiff: 0.12,
      );
      
      // Assert
      expect(tCurrencyRate, isNot(equals(differentRate)));
    });

    test('should handle null optional values', () {
      // Arrange
      const rateWithNulls = CurrencyRate(
        date: '2025-09-10',
        close: 5.4317,
      );
      
      // Assert
      expect(rateWithNulls.date, '2025-09-10');
      expect(rateWithNulls.close, 5.4317);
      expect(rateWithNulls.open, null);
      expect(rateWithNulls.high, null);
      expect(rateWithNulls.low, null);
      expect(rateWithNulls.closeDiff, null);
    });
  });
}
