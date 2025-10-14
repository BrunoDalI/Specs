import 'package:flutter/material.dart';


class CopyrightBanner extends StatelessWidget {
  final String text;
  final Color backgroundColor;

  const CopyrightBanner({
    super.key,
    this.text = 'Copyright 2025 - Action Labs',
    this.backgroundColor = const Color(0xFF03A9F4),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}

