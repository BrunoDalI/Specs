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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12, 
                fontWeight: FontWeight.normal, 
                color: Colors.black
              ),
            ),
          ),
          const SizedBox(width: 8, height: 10),
          Flexible(
            child: Text(
              FormatUtils.formatCurrency(value ?? 0.0),
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14, 
                fontWeight: FontWeight.bold, 
                color: Colors.black
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}