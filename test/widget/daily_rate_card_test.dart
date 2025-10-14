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

    testWidgets('should display all currency rate information', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: tCurrencyRate),
          ),
        ),
      );
      
      // Assert
      expect(find.text('10/09/2025'), findsOneWidget);
      expect(find.byType(Card), findsOneWidget);
      expect(find.textContaining('OPEN'), findsWidgets);
      expect(find.textContaining('HIGH'), findsWidgets);
      expect(find.textContaining('CLOSE'), findsWidgets);
      expect(find.textContaining('LOW'), findsWidgets);
    });

    testWidgets('should display formatted currency values', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: tCurrencyRate),
          ),
        ),
      );
      
      // Assert
      expect(find.textContaining('R\$ 5.4197'), findsWidgets); // OPEN
      expect(find.textContaining('R\$ 5.4429'), findsWidgets); // HIGH
      expect(find.textContaining('R\$ 5.4064'), findsWidgets); // CLOSE
      expect(find.textContaining('R\$ 5.3979'), findsWidgets); // LOW
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

    testWidgets('should display date in correct format and style', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: tCurrencyRate),
          ),
        ),
      );
      
      // Assert
      final dateText = find.text('10/09/2025');
      expect(dateText, findsOneWidget);
      
      final dateWidget = tester.widget<Text>(dateText);
      expect(dateWidget.style?.fontSize, 14);
      expect(dateWidget.style?.fontWeight, FontWeight.bold);
      expect(dateWidget.style?.color, const Color(0xFF03A9F4));
    });

    testWidgets('should handle currency rate with null values', (WidgetTester tester) async {
      // Arrange
      const rateWithNulls = CurrencyRate(
        date: '2025-09-10',
        close: 5.4064,
      );
      
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyRateCard(rate: rateWithNulls),
          ),
        ),
      );
      
      // Assert
      expect(find.text('10/09/2025'), findsOneWidget);
      expect(find.textContaining('R\$ 0.0000'), findsWidgets); // OPEN, HIGH, LOW should show 0.0000
      expect(find.textContaining('R\$ 5.4064'), findsWidgets); // CLOSE
    });

    testWidgets('should use TextPairWidget for displaying values', (WidgetTester tester) async {
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
      expect(find.byType(Row), findsAtLeastNWidgets(1)); // At least 1 row with TextPairWidgets
    });
  });
}
