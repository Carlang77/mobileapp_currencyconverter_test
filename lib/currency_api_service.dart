import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyApiService {
  static const apiKey = 'fca_live_tJLtoYsv4DBH1uXqhD1PFvdxXCuwjo5IuFeWGrVU';
  static const apiUrl = 'https://freecurrencyapi.com/api/v1/rates';

  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    final uri = Uri.parse('$apiUrl?apikey=$apiKey&base_currency=$baseCurrency');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
