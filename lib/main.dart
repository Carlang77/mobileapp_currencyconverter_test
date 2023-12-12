import 'package:flutter/material.dart';
import 'currency_api_service.dart'; // Ensure this import points to your API service file

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile App Quiz | Currency Exchange',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExchangeScreen(),
    );
  }
}

class ExchangeScreen extends StatefulWidget {
  @override
  _ExchangeScreenState createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  final TextEditingController _amountController = TextEditingController();
  double _convertedAmount = 0.0;
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _exchangeRate = 0.85; // Initial exchange rate
  final CurrencyApiService _apiService = CurrencyApiService();

  @override
  void initState() {
    super.initState();
    _refreshExchangeRate(); // Fetch the latest exchange rate when the widget is first created
  }

  void _refreshExchangeRate() async {
    try {
      final rate =
          await _apiService.getExchangeRate(_fromCurrency, _toCurrency);
      setState(() {
        _exchangeRate = rate;
      });
    } catch (error) {
      print('Error fetching exchange rate: $error');
    }
  }

  void _convertCurrency() {
    setState(() {
      _convertedAmount =
          (double.tryParse(_amountController.text) ?? 0) * _exchangeRate;
    });
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;
      _refreshExchangeRate(); // Refresh exchange rate for new currency pair
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshExchangeRate,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Amount in $_fromCurrency',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: 'Enter amount',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _swapCurrencies,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.swap_horiz,
                  color: Color.fromARGB(255, 2, 75, 245),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount in $_toCurrency',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              (_fromCurrency == 'EUR' ? '€ ' : '\$ ') + '$_convertedAmount',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 1, 9, 248),
              const Color.fromARGB(255, 82, 94, 255)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
