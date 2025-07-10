import 'package:flutter/material.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/config/app_colors.dart';
import './currency_selector.dart';

class CurrencySelectorContainer extends ConsumerWidget {
  const CurrencySelectorContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencies = ref.watch(selectedCurrencyProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Stack(
            children: [
              //Contenedor con los selectores de moneda
              Container(
                //rounded border with appcolors.primary color
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                margin: const EdgeInsets.symmetric(vertical: 3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 1.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CurrencySelector(currency: currencies.from, isfrom: true),
                    CurrencySelector(currency: currencies.to, isfrom: false),
                  ],
                ),
              ),

              //Boton de cambio
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => ref.read(selectedCurrencyProvider.notifier).toggle(),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.sync_alt, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        //labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [SelectorLabel('tengo'), SelectorLabel('quiero')],
          ),
        ),
      ],
    );
  }
}

class SelectorLabel extends StatelessWidget {
  const SelectorLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      color: Colors.white,
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9.0, height: 1.0),
      ),
    );
  }
}
