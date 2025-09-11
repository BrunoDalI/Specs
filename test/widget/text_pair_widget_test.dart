import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:specs/features/exchange/presentation/widgets/text_pair.dart';

void main() {
  group('TextPairWidget', () {
    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange
      const label = 'OPEN';
      const value = 5.4317;
      
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextPairWidget(
              label: label,
              value: value,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(RichText), findsOneWidget);
      expect(find.byType(TextPairWidget), findsOneWidget);
    });

    testWidgets('should handle null value without errors', (WidgetTester tester) async {
      // Arrange
      const label = 'HIGH';
      const double? value = null;
      
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextPairWidget(
              label: label,
              value: value,
            ),
          ),
        ),
      );
      
      // Assert
      expect(find.byType(RichText), findsOneWidget);
      expect(find.byType(TextPairWidget), findsOneWidget);
    });

    testWidgets('should create widget with correct properties', (WidgetTester tester) async {
      // Arrange
      const label = 'OPEN';
      const value = 5.4317;
      
      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TextPairWidget(
              label: label,
              value: value,
            ),
          ),
        ),
      );
      
      // Assert
      final textPairWidget = tester.widget<TextPairWidget>(find.byType(TextPairWidget));
      expect(textPairWidget.label, 'OPEN');
      expect(textPairWidget.value, 5.4317);
    });
  });
}
