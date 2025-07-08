import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';
import 'dart:ui' as ui;

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
    final isLoading = amountInput.isLoading;

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoRow(label: "Tasa estimada", value: '≈ ${amountInput.estimatedRate} ${selectedTo.code}'),
              InfoRow(label: "Recibirás", value: '≈ ${amountInput.convertedAmount} ${selectedTo.code}'),
              InfoRow(label: "Tiempo estimado", value: '≈ ${amountInput.time} min'),
            ],
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
