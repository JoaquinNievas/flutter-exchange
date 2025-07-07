import 'package:flutter/material.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/models/currency.dart';
import './bottom_currency_list.dart';

class CurrencySelector extends ConsumerWidget {
  const CurrencySelector({super.key, required this.currency, required this.isfrom});
  final Currency currency;
  final bool isfrom;

  void _showSelector(BuildContext context, List<Currency> currencies, void Function(Currency) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: BottomCurrencyList(
            currencies: currencies,
            currencyType: currency.type,
            onSelected: (c) {
              Navigator.pop(context);
              onSelected(c);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final currencies = ref.watch(currencyListProvider);
        final selectedList = currency.type == CurrencyType.fiat
            ? currencies.fiatCurrencies
            : currencies.cryptoCurrencies;

        _showSelector(context, selectedList, (c) {
          if (isfrom) {
            ref.read(selectedCurrencyProvider.notifier).setFrom(c);
            return;
          }
          ref.read(selectedCurrencyProvider.notifier).setTo(c);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(currency.flagPath, width: 24, height: 24),
            SizedBox(width: 8),
            Text(currency.code),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class CurrencySelectorBox extends ConsumerWidget {
  const CurrencySelectorBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ref.watch(selectedCurrencyProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CurrencySelector(currency: currencies.from, isfrom: true),
        GestureDetector(
          onTap: () => ref.read(selectedCurrencyProvider.notifier).toggle(),
          child: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(Icons.sync_alt, color: Colors.white),
          ),
        ),
        CurrencySelector(currency: currencies.to, isfrom: false),
      ],
    );
  }
}
