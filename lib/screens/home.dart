import 'package:flutter/material.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/models/index.dart';
import 'package:flutter_exchange/components/currency_selector.dart';
import 'package:flutter_exchange/components/info_section.dart';
import 'package:flutter_exchange/components/input_field.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Currency? selectedFrom;
  Currency? selectedTo;
  static const _globalSpacing = 20.0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(currencyListProvider.notifier).fetchCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final showLoader = !ref.watch(isDatareadyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFE6FAFB),
      body: Center(
        child: showLoader
            ? CircularProgressIndicator()
            : Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: _globalSpacing,
                  children: [
                    // Monedas
                    Padding(
                      padding: const EdgeInsets.fromLTRB(_globalSpacing, _globalSpacing, _globalSpacing, 0),
                      child: CurrencySelectorBox(),
                    ),

                    // Monto
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _globalSpacing),
                      child: AmountInputField(),
                    ),

                    // Info
                    InfoSection(),

                    // Botón
                    Padding(
                      padding: const EdgeInsets.fromLTRB(_globalSpacing, 0, _globalSpacing, _globalSpacing),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text("Cambiar", style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
