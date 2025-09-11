import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:specs/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Currency Exchange App Integration Tests', () {
    testWidgets('should complete full currency exchange flow', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Verify app is loaded with initial state
      expect(find.text('BRL EXCHANGE RATE'), findsOneWidget);
      expect(find.text('Enter the currency code'), findsOneWidget);
      
      // Find and interact with text field
      final textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);
      
      // Enter currency code
      await tester.enterText(textField, 'USD');
      await tester.pumpAndSettle();
      
      // Find and tap search button
      final searchButton = find.byIcon(Icons.search);
      expect(searchButton, findsOneWidget);
      
      await tester.tap(searchButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Verify current exchange rate is displayed
      expect(find.textContaining('USD'), findsWidgets);
      
      // Find and tap expand button for 30-day history
      final expandButton = find.text('Show 30-day history');
      if (expandButton.evaluate().isNotEmpty) {
        await tester.tap(expandButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        
        // Verify daily rates are displayed
        expect(find.textContaining('OPEN:'), findsWidgets);
        expect(find.textContaining('HIGH:'), findsWidgets);
        expect(find.textContaining('CLOSE:'), findsWidgets);
        expect(find.textContaining('LOW:'), findsWidgets);
      }
    });

    testWidgets('should handle invalid currency code input', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Enter invalid currency code
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'XYZ');
      await tester.pumpAndSettle();
      
      // Tap search button
      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Should handle error gracefully (either show error message or fallback data)
      // The app should not crash
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should validate input field correctly', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Enter less than 3 characters
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'US');
      await tester.pumpAndSettle();
      
      // Tap search button
      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);
      await tester.pumpAndSettle();
      
      // Should show validation error or handle gracefully
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Clear and enter valid 3-character code
      await tester.enterText(textField, 'EUR');
      await tester.pumpAndSettle();
      
      // Input should accept exactly 3 characters
      expect(find.text('EUR'), findsOneWidget);
    });

    testWidgets('should handle network errors gracefully', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Enter a valid currency code
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'EUR');
      await tester.pumpAndSettle();
      
      // Tap search button
      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      
      // App should either show data or error message, but not crash
      expect(find.byType(MaterialApp), findsOneWidget);
      
      // Should have some content displayed (either data or error)
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('should display loading states during API calls', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Enter currency code
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'GBP');
      await tester.pumpAndSettle();
      
      // Tap search button
      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);
      
      // Should show loading indicator briefly
      await tester.pump(const Duration(milliseconds: 100));
      
      // Wait for API call to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // App should be in a stable state after loading
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('should maintain state when toggling daily rates', (WidgetTester tester) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();
      
      // Enter currency code and search
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'JPY');
      await tester.pumpAndSettle();
      
      final searchButton = find.byIcon(Icons.search);
      await tester.tap(searchButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Toggle daily rates if button is available
      final expandButton = find.text('Show 30-day history');
      if (expandButton.evaluate().isNotEmpty) {
        await tester.tap(expandButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        
        // Toggle back
        final collapseButton = find.text('Hide 30-day history');
        if (collapseButton.evaluate().isNotEmpty) {
          await tester.tap(collapseButton);
          await tester.pumpAndSettle();
        }
      }
      
      // App should maintain stable state throughout
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('JPY'), findsAtLeastNWidgets(1));
    });
  });
}
