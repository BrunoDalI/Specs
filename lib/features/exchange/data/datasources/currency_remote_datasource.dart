import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../domain/entities/currency_rate.dart';

abstract class CurrencyRemoteDataSource {
  Future<List<CurrencyRate>> getRates(String currencyCode);
  Future<List<CurrencyRate>> getDailyRates(String currencyCode);
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final Dio dio;

  CurrencyRemoteDataSourceImpl({required this.dio});
  

  @override
  Future<List<CurrencyRate>> getRates(String currencyCode) async {
    try {
      final response = await dio.get(
        '/open/currentExchangeRate',
        queryParameters: {
          'apiKey': dotenv.env['API_KEY'],
          // 'from_symbol': 'BRL',
          // 'to_symbol': currencyCode,
          'from_symbol': currencyCode,
          'to_symbol': 'BRL',
        },
      );

      if (response.statusCode == 200) {
        return _parseRates(response.data, currencyCode);
      }
      throw Exception('Failed to load rates: ${response.statusCode}');
    } on DioException catch (e) {
      
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Check your internet connection.');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  List<CurrencyRate> _parseRates(dynamic data, String currencyCode) {
    final rates = <CurrencyRate>[];
    
    if (data is Map<String, dynamic>) {
      final exchangeRate = data['exchangeRate']?.toString() ?? 
        data['rate']?.toString() ?? 
        data['value']?.toString() ?? 
        data['close']?.toString() ?? '0';
      
      final timestamp = data['timestamp']?.toString() ??  
        data['date']?.toString() ??  
        DateTime.now().toIso8601String();
      
      rates.add(CurrencyRate(
        date: timestamp,
        close: double.tryParse(exchangeRate) ?? 0.0,
      ));
    }
    
    return rates;
  }

  @override
  Future<List<CurrencyRate>> getDailyRates(String currencyCode) async {
    try {
      final response = await dio.get(
        '/open/dailyExchangeRate',
        queryParameters: {
          'apiKey': dotenv.env['API_KEY'],
          // 'from_symbol': 'BRL',
          // 'to_symbol': currencyCode,
          'from_symbol': currencyCode,
          'to_symbol': 'BRL',
          //'limit': 30, // Como a api n tem um limite definido forcei mostrar os ultimos 30 registros na linha 91
        },
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          return [];
        }
      
        final rates = _parseDailyRates(response.data);
        return rates.take(30).toList(); // Limitei os ultimos 30 registros
      }
      throw Exception('Failed to load daily rates: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Check your internet connection.');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  List<CurrencyRate> _parseDailyRates(dynamic data) {
    final rates = <CurrencyRate>[];
    
    if (data != null) {
      String dataStr = data.toString();
      if (dataStr.length > 100) {
        dataStr = '${dataStr.substring(0, 100)}...';
      }
    }
    
    
    try {
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final dataList = data['data'];
        if (dataList is List) {
          for (var item in dataList) {
            if (item is Map<String, dynamic>) {
              final rate = _createRateFromMap(item);
              if (rate != null) {
                rates.add(rate);
              }
            }
          }
        }
      }

      else if (data is List) {
        for (var item in data) {
          if (item is Map<String, dynamic>) {
            final rate = _createRateFromMap(item);
            if (rate != null) {
              rates.add(rate);
            }
          }
        }
      } 

      else if (data is Map<String, dynamic>) {
        if (data.containsKey('results')) {
          final results = data['results'];
          if (results is List) {
            for (var item in results) {
              if (item is Map<String, dynamic>) {
                final rate = _createRateFromMap(item);
                if (rate != null) {
                  rates.add(rate);
                }
              }
            }
          }
        }
        else {
          final rate = _createRateFromMap(data);
          if (rate != null) {
            rates.add(rate);
          }
        }
      }
    } catch (e) {
      //print('Error parsing daily rates: $e');
    }
    
    if (rates.isEmpty) {
      rates.add(CurrencyRate(
        date: DateTime.now().toIso8601String(),
        close: 0.0,
      ));
    }
    
    rates.sort((a, b) => b.date.compareTo(a.date));
    
    return rates;
  }
  
  CurrencyRate? _createRateFromMap(Map<String, dynamic> item) {
    try {
      final closeValue = item['close']?.toString() ?? 
        item['rate']?.toString() ?? 
        item['value']?.toString() ?? 
        item['exchangeRate']?.toString() ?? 
        '0';
                        
      final openValue = item['open']?.toString() ?? closeValue;
      final highValue = item['high']?.toString() ?? closeValue;
      final lowValue = item['low']?.toString() ?? closeValue;
                        
      final date = item['date']?.toString() ?? item['timestamp']?.toString() ?? DateTime.now().toIso8601String();
      
      double closeDouble = _parseDoubleValue(closeValue);
      double openDouble = _parseDoubleValue(openValue);
      double highDouble = _parseDoubleValue(highValue);
      double lowDouble = _parseDoubleValue(lowValue);
      
      return CurrencyRate(
        date: date,
        close: closeDouble,
        open: openDouble,
        high: highDouble,
        low: lowDouble,
      );
    } catch (e) {
      return null;
    }
  }
  
  double _parseDoubleValue(String value) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
}