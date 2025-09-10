import 'package:flutter/material.dart';
import 'package:specs/features/exchange/presentation/widgets/format_date.dart';
import '../../domain/entities/currency_rate.dart';

class ExchangeResultWidget extends StatelessWidget {
  final String fromSymbol;
  final String toSymbol;
  final CurrencyRate? rate;

  const ExchangeResultWidget({
    super.key,
    required this.fromSymbol,
    required this.toSymbol,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = constraints.maxWidth * 0.97;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(thickness: 1),
              const SizedBox(height: 16),
              SizedBox(
                width: contentWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exchange rate now',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          Text(
                            formatDate(rate?.date),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${toSymbol.toUpperCase()}/${fromSymbol.toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03A9F4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: contentWidth,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                  ),
                  child: Text(
                    'R\$ ${rate?.close.toStringAsFixed(2).replaceAll('.', ',') ?? '0,00'}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF03A9F4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
