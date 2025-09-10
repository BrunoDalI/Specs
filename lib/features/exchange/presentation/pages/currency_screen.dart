import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_bloc.dart';
import '../bloc/currency_event.dart';
import '../bloc/currency_state.dart';
import '../widgets/copy_right_banner.dart';
import '../widgets/exchange_result.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Image.asset('assets/logo/logo.png', height: 50, width: 300),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Divider(thickness: 2),
              ),
              const SizedBox(height: 16),
              const Text(
                'BRL EXCHANGE RATE',
                style: TextStyle(
                  color: Color(0xFF03A9F4),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Enter the currency code',
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    labelStyle: TextStyle(color: Color(0xFF03A9F4), fontSize: 16),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF03A9F4))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF03A9F4), width: 2)),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF03A9F4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: () {
                      context.read<CurrencyBloc>().add(
                        LoadCurrencyRates(currencyCode: controller.text),
                      );
                    },
                    child: const Text('EXCHANGE RESULT', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<CurrencyBloc, CurrencyState>(
                  builder: (context, state) {
                    if (state is CurrencyLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is CurrencyLoaded) {
                      final rate = state.rates.isNotEmpty ? state.rates.first : null;
                      return ExchangeResultWidget(
                        fromSymbol: 'BRL',
                        toSymbol: controller.text,
                        rate: rate,
                      );
                    }
                    if (state is CurrencyError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: const CopyrightBanner(),
      ),
    );
  }
}
