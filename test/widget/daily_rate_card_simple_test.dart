import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specs/features/exchange/domain/entities/currency_rate.dart';
import 'package:specs/features/exchange/presentation/widgets/daily_rate_card.dart';

void main() {
  group('DailyRateCard', () {
    const tCurrencyRate = CurrencyRate(
      date: '2025-09-10T00:00:00',
      close: 5.4064,
      open: 5.4197,
      high: 5.4429,
      low: 5.3979,
      closeDiff: -0.0133,
    );

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: tCurrencyRate),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(DailyRateCard), findsOneWidget);
    });

    testWidgets('should use Card widget with correct styling', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: tCurrencyRate),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(Card), findsOneWidget);
      
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.color, Colors.white);
      expect(card.elevation, 2);
      expect(card.shape, const RoundedRectangleBorder(borderRadius: BorderRadius.zero));
    });

    testWidgets('should handle currency rate with null values', (WidgetTester tester) async {
      // Arrange
      const nullCurrencyRate = CurrencyRate(
        date: '2025-10-15T00:00:00',
        close: 0.0,
        open: 0.0,
        high: 0.0,
        low: 0.0,
        closeDiff: 0.0,
      );
      
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: nullCurrencyRate),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(DailyRateCard), findsOneWidget);
    });
  });
}
