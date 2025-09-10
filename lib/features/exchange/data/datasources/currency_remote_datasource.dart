import 'package:dio/dio.dart';
import '../../domain/entities/currency_rate.dart';

abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyRate>> getRates(String currencyCode);
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CurrencyRate>> getRates(String currencyCode) async {
    try {
      //URL corrigida baseada na documentação
      final response = await dio.get(
        '/open/currentExchangeRate',
        queryParameters: {
          'apiKey': 'RVZG0GHEV2KORLNA',
          'from_symbol': 'BRL',
          'to_symbol': currencyCode,
        },
      );
    

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return _parseRates(response.data, currencyCode);
      }
      throw Exception('Failed to load rates: ${response.statusCode}');
    } on DioException catch (e) {
      print('DioException: ${e.type}');
      print('DioException message: ${e.message}');
      print('DioException response: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Check your internet connection.');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('General error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  List<CurrencyRate> _parseRates(dynamic data, String currencyCode) {
    final rates = <CurrencyRate>[];
    
    print('Parsing data: $data');
    
    if (data is Map<String, dynamic>) {
      final exchangeRate = data['exchangeRate']?.toString() ?? 
        data['rate']?.toString() ?? 
        data['value']?.toString() ?? 
        data['close']?.toString() ?? '0';
      
      final timestamp = data['timestamp']?.toString() ??  data['date']?.toString() ??  DateTime.now().toIso8601String();
      
      rates.add(CurrencyRate(
        date: timestamp.contains('T') ? timestamp.split('T')[0] : timestamp,
        close: double.tryParse(exchangeRate) ?? 0.0,
      ));
    }
    
    return rates;
  }
}