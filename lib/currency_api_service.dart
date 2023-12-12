import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyApiService {
  static const String apiKey =
      'fca_live_tJLtoYsv4DBH1uXqhD1PFvdxXCuwjo5IuFeWGrVU';
  static const String apiUrl = 'https://api.freecurrencyapi.com/v1/latest';

  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    final uri = Uri.parse('$apiUrl?apikey=$apiKey&base_currency=$baseCurrency');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(
          'API Error - Status Code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to load exchange rates');
    }
  }

  Future<double> getExchangeRate(String fromCurrency, String toCurrency) async {
    final responseMap = await getExchangeRates(fromCurrency);

    if (responseMap.containsKey('data')) {
      final rates = responseMap['data'][toCurrency];
      if (rates != null) {
        return double.tryParse(rates.toString()) ??
            (throw Exception('Failed to parse rate'));
      } else {
        throw Exception('Rate for $toCurrency not found');
      }
    } else {
      throw Exception('Invalid response structure');
    }
  }
}
