import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class InfoSection extends ConsumerWidget {
  const InfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTo = ref.watch(selectedCurrencyProvider.select((s) => s.to));
    final amountInput = ref.watch(amountInputProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(label: "Tasa estimada", value: '≈ ${amountInput.estimatedRate} ${selectedTo.code}'),
        InfoRow(label: "Recibirás", value: '≈ ${amountInput.convertedAmount} ${selectedTo.code}'),
        InfoRow(label: "Tiempo estimado", value: '≈ ${amountInput.time} min'),
      ],
    );
  }
}
