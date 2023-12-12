// main.dart
import 'package:flutter/material.dart';
import 'currency_api_service.dart';
import 'exchange_rate_model.dart';
import 'exchange_rate_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Exchange App',
      home: ExchangeScreen(),
    );
  }
}

class ExchangeScreen extends StatefulWidget {
  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  late Future<Map<String, dynamic>?> _exchangeRates;
  final _apiService = CurrencyApiService();
  final TextEditingController _baseCurrencyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _exchangeRates = _apiService.getExchangeRates('EUR');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Exchange App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _exchangeRates =
                    _apiService.getExchangeRates(_baseCurrencyController.text);
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _baseCurrencyController,
              decoration: InputDecoration(labelText: 'Base Currency'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _exchangeRates = _apiService.getExchangeRates('USD');
                    });
                  },
                  child: Text('USD'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _exchangeRates = _apiService.getExchangeRates('EUR');
                    });
                  },
                  child: Text('EUR'),
                ),
              ],
            ),
            FutureBuilder<Map<String, dynamic>?>(
              future: _exchangeRates,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  try {
                    print('API Response: ${snapshot.data}');

                    final List<ExchangeRate> rates = [];
                    final Map<String, dynamic>? responseData = snapshot.data;

                    if (responseData != null && responseData['data'] != null) {
                      final Map<String, dynamic>? ratesData =
                          responseData['data']['rates'];

                      if (ratesData != null) {
                        ratesData.forEach((currency, rate) {
                          rates.add(ExchangeRate(currency, rate.toDouble()));
                        });
                      } else {
                        return Text('No rates data in the response');
                      }
                    } else {
                      return Text('Invalid data structure in the response');
                    }

                    return Column(
                      children: rates
                          .map((rate) => ExchangeRateWidget(
                              currency: rate.currency, rate: rate.rate))
                          .toList(),
                    );
                  } catch (e) {
                    return Text('Error processing data: $e');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
