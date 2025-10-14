

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatUtils {
  static String formatCurrency(double value) {
    return "R\$ ${value.toStringAsFixed(4)}";
  }

  static String formatDate(String isoDate) {
    try {
      if (isoDate.contains('T')) {
        final parsedDate = DateTime.parse(isoDate);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }
      final dateParts = isoDate.split('-');
      if (dateParts.length == 3) {
        return "${dateParts[2]}/${dateParts[1]}/${dateParts[0]}";
      }
      return isoDate;
    } catch (_) {
      return isoDate;
    }
  }

  static String formatDiffPercentage(double? open, double? close) {
    if (open == null || close == null || open == 0) return "N/A";
    final diffPct = ((close - open) / open) * 100;
    final sign = diffPct >= 0 ? "+" : "";
    return "$sign${diffPct.toStringAsFixed(2)}%";
  }

  static Color getDiffColor(double? open, double? close) {
    if (open == null || close == null || open == 0) return Colors.grey;
    final diffPct = ((close - open) / open) * 100;
    if (diffPct > 0) return const Color(0xFF4CAF50); 
    if (diffPct < 0) return const Color(0xFFF44336); 
    return Colors.grey;
  }

  static IconData getDiffIcon(double? open, double? close) {
    if (open == null || close == null || open == 0) return Icons.remove;
    final diffPct = ((close - open) / open) * 100;
    if (diffPct > 0) return Icons.keyboard_arrow_up;
    if (diffPct < 0) return Icons.keyboard_arrow_down;
    return Icons.remove;
  }

  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    } else if (screenWidth > 600) {
      return baseSize * 1.1;
    }
    return baseSize;
  }

  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    } else if (screenWidth > 600) {
      return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  }
}