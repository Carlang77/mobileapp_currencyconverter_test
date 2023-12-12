import 'package:flutter/material.dart';
import 'currency_api_service.dart'; // Ensure this import points to your API service file

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency EXchange',
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
  double _exchangeRate = 0.0;
  final CurrencyApiService _apiService = CurrencyApiService();

  String _fromCurrency = 'EUR';
  String _toCurrency = 'USD';
  List<String> currencies = ['EUR', 'USD', 'GBP', 'CAD'];

  @override
  void initState() {
    super.initState();
    _refreshExchangeRate();
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
      final amount = double.tryParse(_amountController.text) ?? 0;
      _convertedAmount = amount * _exchangeRate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Exchange'),
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
              Colors.blue[700]!,
              Colors.blue[300]!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _fromCurrency,
              icon: Icon(Icons.arrow_downward, color: Colors.white),
              onChanged: (String? newValue) {
                setState(() {
                  _fromCurrency = newValue!;
                  _refreshExchangeRate();
                });
              },
              items: currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              value: _toCurrency,
              icon: Icon(Icons.arrow_downward, color: Colors.white),
              onChanged: (String? newValue) {
                setState(() {
                  _toCurrency = newValue!;
                  _refreshExchangeRate();
                });
              },
              items: currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(
                hintText: 'Enter $_fromCurrency',
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
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertCurrency,
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 5,
              ),
              child: Text(
                'Convert',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            Text(
              '$_toCurrency ${_convertedAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
