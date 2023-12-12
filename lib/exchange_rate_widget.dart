// exchange_rate_widget.dart
import 'package:flutter/material.dart';

class ExchangeRateWidget extends StatelessWidget {
  final String currency;
  final double rate;

  ExchangeRateWidget({required this.currency, required this.rate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$currency to USD'),
      subtitle: Text('Exchange Rate: $rate'),
    );
  }
}
