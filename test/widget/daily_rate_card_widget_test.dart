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

    testWidgets('should render card layout correctly', (WidgetTester tester) async {
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
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle different currency rate values', (WidgetTester tester) async {
      // Arrange
      const currencyRate = CurrencyRate(
        date: '2025-10-15T00:00:00',
        close: 6.1110,
        open: 6.1234,
        high: 6.2000,
        low: 6.0987,
        closeDiff: -0.0050,
      );
      
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: currencyRate),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(DailyRateCard), findsOneWidget);
    });
  });
}
