import 'package:flutter/material.dart';
import 'package:flutter_exchange/config/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';

class AmountInputField extends ConsumerWidget {
  const AmountInputField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFrom = ref.watch(selectedCurrencyProvider.select((s) => s.from));
    final intialAmount = ref.watch(amountInputProvider.select((s) => s.amount));

    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        prefixText: '${selectedFrom.code} ',
        prefixStyle: TextStyle(color: AppColors.primary, fontSize: 15),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      initialValue: intialAmount.toString(),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
      onFieldSubmitted: (value) => ref.read(amountInputProvider.notifier).update(value),
    );
  }
}
