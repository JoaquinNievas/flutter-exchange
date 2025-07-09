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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CurrencySelector(currency: currencies.from, isfrom: true),
        GestureDetector(
          onTap: () => ref.read(selectedCurrencyProvider.notifier).toggle(),
          child: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Icon(Icons.sync_alt, color: Colors.white),
          ),
        ),
        CurrencySelector(currency: currencies.to, isfrom: false),
      ],
    );
  }
}
