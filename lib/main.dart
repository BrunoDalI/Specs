import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection_container.dart' as di;
import 'features/exchange/presentation/bloc/currency_bloc.dart';
import 'features/exchange/presentation/pages/currency_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => di.sl<CurrencyBloc>(),
        child: CurrencyScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}