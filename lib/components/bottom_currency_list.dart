import 'package:flutter/material.dart';
import 'package:flutter_exchange/models/index.dart';

class BottomCurrencyList extends StatelessWidget {
  const BottomCurrencyList({super.key, required this.currencies, required this.currencyType, required this.onSelected});
  final List<Currency> currencies;
  final CurrencyType currencyType;
  final void Function(Currency) onSelected;

  String get currencyTypeLabel {
    switch (currencyType) {
      case CurrencyType.fiat:
        return "FIAT";
      case CurrencyType.crypto:
        return "Cripto";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 5,
          width: 50,
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
        ),
        Text(currencyTypeLabel, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ListView.builder(
          shrinkWrap: true,
          itemCount: currencies.length,
          itemBuilder: (context, index) {
            final currency = currencies[index];
            return ListTile(
              leading: Image.asset(currency.flagPath, width: 30, height: 30),
              title: Text(currency.code),
              subtitle: Text('${currency.name} (${currency.symbol})'),
              onTap: () => onSelected(currency),
            );
          },
        ),
      ],
    );
  }
}
