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
  double _exchangeRate = 0.85; // Initial exchange rate
  final CurrencyApiService _apiService = CurrencyApiService();
  bool _isConvertingFromUSD = true; // New state variable

  @override
  void initState() {
    super.initState();
    _refreshExchangeRate();
  }

  void _refreshExchangeRate() async {
    try {
      final fromCurrency = _isConvertingFromUSD ? 'USD' : 'EUR';
      final toCurrency = _isConvertingFromUSD ? 'EUR' : 'USD';
      final rate = await _apiService.getExchangeRate(fromCurrency, toCurrency);
      setState(() {
        _exchangeRate = rate;
      });
    } catch (error) {
      print('Error fetching exchange rate: $error');
    }
  }

  void _convertCurrency() {
    setState(() {
      final amount = double.tryParse(_amountController.text) ?? 0;
      double rawConvertedAmount = _isConvertingFromUSD
          ? amount * _exchangeRate
          : amount / _exchangeRate;
      _convertedAmount = double.parse(rawConvertedAmount.toStringAsFixed(2));
    });
  }

  void _toggleCurrency() {
    setState(() {
      _isConvertingFromUSD = !_isConvertingFromUSD;
      _refreshExchangeRate();
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
              'Currency',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: _isConvertingFromUSD
                    ? 'Enter amount in USD'
                    : 'Enter amount in EUR',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the text bold
                fontSize: 40, // Match the font size of the converted amount
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _convertCurrency,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.swap_vert,
                  color: Color.fromARGB(255, 2, 75, 245),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              '${_isConvertingFromUSD ? '€' : '\$'} ${_convertedAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleCurrency,
              child: Text(_isConvertingFromUSD
                  ? 'Switch to EUR to USD'
                  : 'Switch to USD to EUR'),
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
