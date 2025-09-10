import 'package:flutter/material.dart';
import 'package:specs/core/utils/format_utils.dart';

class TextPairWidget extends StatelessWidget {
  final String label;
  final double? value;

  const TextPairWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$label:   ',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
        children: [
          TextSpan(
            text: FormatUtils.formatCurrency(value ?? 0.0),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}