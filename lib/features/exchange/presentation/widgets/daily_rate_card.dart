import 'package:flutter/material.dart';
import 'package:specs/core/utils/format_utils.dart';
import 'package:specs/features/exchange/domain/entities/currency_rate.dart';
import 'package:specs/features/exchange/presentation/widgets/text_pair.dart';


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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
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
                  TextPairWidget(label: 'OPEN', value: rate.open),
                  TextPairWidget(label: 'HIGH', value: rate.high),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextPairWidget(label: 'CLOSE', value: rate.close),
                  TextPairWidget(label: 'LOW', value: rate.low),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text('CLOSE DIFF (%): ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),),
                  Text(
                    closeDiffPercentage,
                    style: TextStyle(fontSize: 16, color: diffColor, fontWeight: FontWeight.bold),
                  ),
                  Icon(diffIcon, size: 25, color: diffColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}