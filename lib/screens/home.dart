import 'package:flutter/material.dart';
import 'package:flutter_exchange/providers/currency_calculator_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_exchange/models/currency.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exchange/components/currency_selector.dart';
import 'package:flutter_exchange/components/info_section.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  Currency? selectedFrom;
  Currency? selectedTo;
  TextEditingController amountController = TextEditingController(text: "5.00");

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
    final selectedFrom = ref.watch(selectedCurrencyProvider.select((s) => s.from));

    return Scaffold(
      backgroundColor: const Color(0xFFE6FAFB),
      body: Center(
        child: showLoader
            ? CircularProgressIndicator()
            : Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Monedas
                    CurrencySelectorBox(),
                    SizedBox(height: 16),

                    // Monto
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        prefixText: '${selectedFrom.code} ',
                        prefixStyle: TextStyle(color: Colors.orange, fontSize: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orange),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.orange, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                    ),
                    SizedBox(height: 20),

                    // Info
                    InfoSection(),
                    SizedBox(height: 20),

                    // Botón
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Cambiar", style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
