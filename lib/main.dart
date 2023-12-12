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
        title: Text('Currency EXCHANGE'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshExchangeRate,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 76, 107, 151), // Top half is white
              const Color.fromARGB(255, 42, 43, 43), // Bottom half is blue
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: _isConvertingFromUSD ? 'Enter USD' : 'Enter EUR',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefix: Text(
                  _isConvertingFromUSD ? '\$ ' : '€ ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Color.fromARGB(255, 89, 89, 91),
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Color.fromARGB(255, 89, 89, 91),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Button background color is white
                elevation: 5, // Add shadow to the button
              ),
              child: Text(
                'Convert',
                style: TextStyle(
                  color: Colors.black, // Text color is black
                  fontWeight: FontWeight.bold,
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
              style: ElevatedButton.styleFrom(
                primary: Colors.white, // Button background color is white
                elevation: 5, // Add shadow to the button
              ),
              child: Text(_isConvertingFromUSD
                  ? 'Switch to EUR to USD'
                  : 'Switch to USD to EUR'),
            ),
          ],
        ),
      ),
    );
  }
}
