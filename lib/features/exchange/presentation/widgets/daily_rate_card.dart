import 'package:flutter/material.dart';
import 'package:specs/core/utils/formt_utils.dart';
import 'package:specs/features/exchange/domain/entities/currency_rate.dart';


class DailyRateCard extends StatelessWidget {
  final CurrencyRate rate;

  const DailyRateCard({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    final closeDiffPercentage = FormatUtils.formatDiffPercentage(rate.open, rate.close);
    final diffColor = FormatUtils.getDiffColor(rate.open, rate.close);
    final diffIcon = FormatUtils.getDiffIcon(rate.open, rate.close);

  
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FormatUtils.formatDate(rate.date),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF03A9F4)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('OPEN: ${FormatUtils.formatCurrency(rate.open ?? 0.0)}'),
                  Text('HIGH: ${FormatUtils.formatCurrency(rate.high ?? 0.0)}'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CLOSE: ${FormatUtils.formatCurrency(rate.close)}'),
                  Text('LOW: ${FormatUtils.formatCurrency(rate.low ?? 0.0)}'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('CLOSE DIFF (%): '),
                  Text(
                    closeDiffPercentage,
                    style: TextStyle(fontSize: 12, color: diffColor, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    diffIcon,
                    size: 25,
                    color: diffColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}