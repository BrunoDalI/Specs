

import 'package:flutter/material.dart';

class FormatUtils {
  static String formatCurrency(double value) {
    return "R\$ ${value.toStringAsFixed(4)}";
  }

  static String formatDate(String isoDate) {
    try {
      final dateParts = isoDate.split('T')[0].split('-');
      return "${dateParts[2]}/${dateParts[1]}/${dateParts[0]}";
    } catch (_) {
      return isoDate;
    }
  }

  static String formatDiffPercentage(double? open, double? close) {
    if (open == null || close == null) return "N/A";
    final diffPct = ((close - open) / open) * 100;
    final sign = diffPct >= 0 ? "+" : "";
    return "$sign${diffPct.toStringAsFixed(2)}%";
  }


  static Color getDiffColor(double? open, double? close) {
    if (open == null || close == null) return Colors.grey;
    final diffPct = ((close - open) / open) * 100;
    if (diffPct > 0) return Colors.green;
    if (diffPct < 0) return Colors.red;
    return Colors.grey;
  }

  static IconData getDiffIcon(double? open, double? close) {
    if (open == null || close == null) return Icons.remove;
    final diffPct = ((close - open) / open) * 100;
    if (diffPct > 0) return Icons.expand_less;
    if (diffPct < 0) return Icons.expand_more;
    return Icons.remove;
  }
}