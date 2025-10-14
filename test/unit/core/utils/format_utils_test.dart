import 'package:flutter_test/flutter_test.dart';
import 'package:specs/core/utils/format_utils.dart';

void main() {
  group('FormatUtils', () {
    group('formatCurrency', () {
      test('should format currency with R\$ prefix and 4 decimal places', () {
        // Arrange
        const value = 5.4317;
        
        // Act
        final result = FormatUtils.formatCurrency(value);
        
        // Assert
        expect(result, 'R\$ 5.4317');
      });

      test('should format zero value correctly', () {
        // Arrange
        const value = 0.0;
        
        // Act
        final result = FormatUtils.formatCurrency(value);
        
        // Assert
        expect(result, 'R\$ 0.0000');
      });

      test('should format negative value correctly', () {
        // Arrange
        const value = -2.5;
        
        // Act
        final result = FormatUtils.formatCurrency(value);
        
        // Assert
        expect(result, 'R\$ -2.5000');
      });
    });

    group('formatDate', () {
      test('should format ISO date to DD/MM/YYYY', () {
        // Arrange
        const isoDate = '2025-09-10T00:00:00';
        
        // Act
        final result = FormatUtils.formatDate(isoDate);
        
        // Assert
        expect(result, '10/09/2025');
      });

      test('should return original string if format is invalid', () {
        // Arrange
        const invalidDate = 'invalid-date';
        
        // Act
        final result = FormatUtils.formatDate(invalidDate);
        
        // Assert
        expect(result, 'invalid-date');
      });

      test('should handle date without time component', () {
        // Arrange
        const dateOnly = '2025-12-25';
        
        // Act
        final result = FormatUtils.formatDate(dateOnly);
        
        // Assert
        expect(result, '25/12/2025');
      });
    });

    group('formatDiffPercentage', () {
      test('should calculate positive percentage with plus sign', () {
        // Arrange
        const open = 5.0;
        const close = 5.5;
        
        // Act
        final result = FormatUtils.formatDiffPercentage(open, close);
        
        // Assert
        expect(result, '+10.00%');
      });

      test('should calculate negative percentage', () {
        // Arrange
        const open = 5.0;
        const close = 4.5;
        
        // Act
        final result = FormatUtils.formatDiffPercentage(open, close);
        
        // Assert
        expect(result, '-10.00%');
      });

      test('should return N/A when open is null', () {
        // Arrange
        const double? open = null;
        const close = 5.0;
        
        // Act
        final result = FormatUtils.formatDiffPercentage(open, close);
        
        // Assert
        expect(result, 'N/A');
      });

      test('should return N/A when close is null', () {
        // Arrange
        const open = 5.0;
        const double? close = null;
        
        // Act
        final result = FormatUtils.formatDiffPercentage(open, close);
        
        // Assert
        expect(result, 'N/A');
      });
    });
  });
}
