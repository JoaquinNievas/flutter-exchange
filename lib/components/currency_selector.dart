import 'package:flutter/material.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/models/index.dart';
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(currency.flagPath, width: 22, height: 22),
          SizedBox(width: 8),
          //Los codigos tienen entre 3 y 4 caracteres, por lo que pongo un ancho minimo de 40
          //por fines estéticos
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 40),
            child: Text(currency.code, style: Theme.of(context).textTheme.labelLarge),
          ),
          const RotatedBox(quarterTurns: 1, child: Icon(Icons.chevron_right_rounded)),
        ],
      ),
    );
  }
}
