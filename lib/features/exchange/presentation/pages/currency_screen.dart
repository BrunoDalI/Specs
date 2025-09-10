import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:specs/features/exchange/presentation/widgets/daily_rate_card.dart';
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
  bool show30Days = false;
  bool isExpanded = false;


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    final currencyCode = controller.text.trim().toUpperCase();
    if (currencyCode.isNotEmpty) {
      setState(() {
        show30Days = true;
      });
      
      context.read<CurrencyBloc>().add(
        LoadCurrencyRates(currencyCode: currencyCode),
      );
      
      if (isExpanded) {
        context.read<CurrencyBloc>().add(
          LoadDailyRates(currencyCode: currencyCode),
        );
      }
    }
  }
  
  void _toggleDailyRates() {
    final currencyCode = controller.text.trim().toUpperCase();
    setState(() {
      isExpanded = !isExpanded;
    });
    
    if (isExpanded && currencyCode.isNotEmpty) {
      context.read<CurrencyBloc>().add(
        LoadDailyRates(currencyCode: currencyCode),
      );
    }
  }

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
                  maxLength: 3,
                  onSubmitted: (_) => _onSearchPressed(),
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
                    onPressed: _onSearchPressed,
                    child: const Text('EXCHANGE RESULT', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<CurrencyBloc, CurrencyState>(
                  buildWhen: (previous, current) => 
                    current is CurrencyInitial ||
                    current is CurrencyLoading || 
                    current is CurrencyLoaded || 
                    (current is CurrencyError && !current.isDaily),
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
                    if (state is CurrencyError && !state.isDaily) {
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

              if (show30Days) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'LAST 30 DAYS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isExpanded ? Icons.remove : Icons.add,
                          color: const Color(0xFF03A9F4),
                        ),
                        onPressed: _toggleDailyRates,
                      ),
                    ],
                  ),
                ),
                if (isExpanded) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: BlocBuilder<CurrencyBloc, CurrencyState>(
                      buildWhen: (previous, current) => 
                        current is DailyRatesInitial ||
                        current is DailyRatesLoading || 
                        current is DailyRatesLoaded || 
                        (current is CurrencyError && current.isDaily),
                      builder: (context, state) {
                        if (state is DailyRatesLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (state is DailyRatesLoaded) {
                          if (state.rates.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('No daily rates available'),
                              ),
                            );
                          }
                          
                          return Card(
                            color: Colors.grey[200],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Column(
                                children: state.rates.map((rate) => DailyRateCard(rate: rate)).toList(),
                              ),
                            ),
                          );
                        }

                        
                        if (state is CurrencyError && state.isDaily) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                state.message,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Divider(
                    thickness: 2,
                    color: Color(0xFF03A9F4),
                  ),
                ),
              ],
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