import 'package:dio/dio.dart';
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
          'apiKey': 'RVZG0GHEV2KORLNA',
          // 'from_symbol': 'BRL',
          // 'to_symbol': currencyCode,
          'from_symbol': currencyCode,
          'to_symbol': 'BRL',
        },
      );
    

      // Debug information - remove in production
      // print('Response status: ${response.statusCode}');
      // print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return _parseRates(response.data, currencyCode);
      }
      throw Exception('Failed to load rates: ${response.statusCode}');
    } on DioException catch (e) {
      // Debug information - remove in production
      // print('DioException: ${e.type}');
      // print('DioException message: ${e.message}');
      // print('DioException response: ${e.response?.data}');
      
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Check your internet connection.');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {

      // print('General error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  List<CurrencyRate> _parseRates(dynamic data, String currencyCode) {
    final rates = <CurrencyRate>[];
    
    // Debug information - remove in production
    // print('Parsing data: $data');
    
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
      //print('Fetching daily rates for $currencyCode');
      
      final response = await dio.get(
        '/open/dailyExchangeRate',
        queryParameters: {
          'apiKey': 'RVZG0GHEV2KORLNA',
          // 'from_symbol': 'BRL',
          // 'to_symbol': currencyCode,
          'from_symbol': currencyCode,
          'to_symbol': 'BRL',
          //'limit': 30,
        },
      );

      //print('Responseeeee $response');
      //print('url: ${response.realUri}');

      //print('Daily rates response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        if (response.data == null) {
          //print('Response data is null');
          return [];
        }
        
        //print('Response data type: ${response.data.runtimeType}');
        
        return _parseDailyRates(response.data);
      }
      throw Exception('Failed to load daily rates: ${response.statusCode}');
    } on DioException catch (e) {
      //print('DioException in getDailyRates: ${e.type}, ${e.message}');
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Connection error. Check your internet connection.');
      }
      if (e.response?.statusCode == 429) {
        throw Exception('Rate limit exceeded. Try again later.');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      //print('Unexpected error in getDailyRates: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  List<CurrencyRate> _parseDailyRates(dynamic data) {
    final rates = <CurrencyRate>[];
    
    //print('Parsing daily rates data type: ${data.runtimeType}');
    if (data != null) {
      String dataStr = data.toString();
      if (dataStr.length > 100) {
        dataStr = '${dataStr.substring(0, 100)}...';
      }
      //print('Parsing daily rates data sample: $dataStr');
    }
    
    bool dataExtracted = false;
    
    try {
      if (data is Map<String, dynamic> && data.containsKey('data')) {
        final dataList = data['data'];
        if (dataList is List) {
          for (var item in dataList) {
            if (item is Map<String, dynamic>) {
              final rate = _createRateFromMap(item);
              if (rate != null) {
                rates.add(rate);
                dataExtracted = true;
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
              dataExtracted = true;
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
                  dataExtracted = true;
                }
              }
            }
          }
        }
        else {
          final rate = _createRateFromMap(data);
          if (rate != null) {
            rates.add(rate);
            dataExtracted = true;
          }
        }
      }
      
      if (!dataExtracted) {
        //print('No data extracted from API response. Using mock data.');
        // Excluir para produção
       // rates.addAll(_getMockDailyRates());
      }
    } catch (e) {
      //print('Error parsing daily rates: $e');
    }
    
    if (rates.isEmpty) {
      //print('No rates were parsed from data');
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
      
      //print('Rate data: date=$date, open=$openDouble, high=$highDouble, low=$lowDouble, close=$closeDouble');
      
      return CurrencyRate(
        date: date,
        close: closeDouble,
        open: openDouble,
        high: highDouble,
        low: lowDouble,
      );
    } catch (e) {
      //print('Error creating rate from map: $e');
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
  
  // Excluir para produção
  /// exemplo teste para validar design e funcionamento
  // List<CurrencyRate> _getMockDailyRates() {
  //   final mockRates = <CurrencyRate>[
  //     CurrencyRate(
  //       date: '2025-09-10T03:00:00.000+00:00',
  //       open: 5.0666,
  //       high: 5.0689,
  //       low: 4.9836,
  //       close: 5.0038,
  //       closeDiff: -0.0577,
  //     ),
  //     CurrencyRate(
  //       date: '2025-09-09T03:00:00.000+00:00',
  //       open: 5.1233,
  //       high: 5.1456,
  //       low: 5.0123,
  //       close: 5.0615,
  //       closeDiff: -0.0430, 
  //     ),
  //     CurrencyRate(
  //       date: '2025-09-08T03:00:00.000+00:00',
  //       open: 5.1045,
  //       high: 5.1233,
  //       low: 5.0897,
  //       close: 5.1045,
  //     ),
  //     CurrencyRate(
  //       date: '2025-09-07T03:00:00.000+00:00',
  //       open: 5.1122,
  //       high: 5.1300,
  //       low: 5.0788,
  //       close: 5.0980,
  //       closeDiff: -0.0065,
  //     ),
  //     CurrencyRate(
  //       date: '2025-09-06T03:00:00.000+00:00',
  //       open: 5.0897,
  //       high: 5.1388,
  //       low: 5.0788,
  //       close: 5.1045,
  //       closeDiff: 0.0148,
  //     ),
  //   ];
    
  //   return mockRates;
  // }
}