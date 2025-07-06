import 'package:flutter/material.dart';

class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag; // path a imagen

  Currency({required this.code, required this.name, required this.symbol, required this.flag});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Dorado',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow)),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Currency> currencies = [
    Currency(code: "VES", name: "Bolívares", symbol: "Bs", flag: "assets/fiat_currencies/VES.png"),
    Currency(code: "COP", name: "Pesos Colombianos", symbol: "COL\$", flag: "assets/fiat_currencies/COP.png"),
    Currency(code: "PEN", name: "Soles Peruanos", symbol: "S/", flag: "assets/fiat_currencies/PEN.png"),
    Currency(code: "BRL", name: "Real Brasileño", symbol: "R\$", flag: "assets/fiat_currencies/BRL.png"),
  ];

  Currency? selectedFrom;
  Currency? selectedTo;
  TextEditingController amountController = TextEditingController(text: "5.00");

  @override
  void initState() {
    super.initState();
    selectedFrom = currencies[0];
    selectedTo = currencies[1];
  }

  void _showCurrencySelector(Currency selected, void Function(Currency) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 5, width: 50, color: Colors.grey[300], margin: EdgeInsets.symmetric(vertical: 10)),
              Text("FIAT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

              ...currencies.map((currency) {
                return ListTile(
                  leading: Image.asset(currency.flag, width: 30, height: 30),
                  title: Text(currency.code),
                  subtitle: Text("${currency.name} (${currency.symbol})"),
                  trailing: Radio<Currency>(
                    value: currency,
                    groupValue: selected,
                    onChanged: (value) {
                      Navigator.pop(context);
                      if (value != null) onSelected(value);
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrencyBox({required String label, required Currency currency, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(currency.flag, width: 24, height: 24),
                SizedBox(width: 8),
                Text(currency.code),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6FAFB),
      body: Center(
        child: Container(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCurrencyBox(
                    label: "TENGO",
                    currency: selectedFrom!,
                    onTap: () => _showCurrencySelector(selectedFrom!, (c) => setState(() => selectedFrom = c)),
                  ),
                  Icon(Icons.sync_alt, color: Colors.orange),
                  _buildCurrencyBox(
                    label: "QUIERO",
                    currency: selectedTo!,
                    onTap: () => _showCurrencySelector(selectedTo!, (c) => setState(() => selectedTo = c)),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Monto
              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: selectedFrom!.code,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
              SizedBox(height: 20),

              // Info
              _buildInfoRow("Tasa estimada", "≈ 25.00 ${selectedTo!.symbol}"),
              _buildInfoRow("Recibirás", "≈ 125.00 ${selectedTo!.symbol}"),
              _buildInfoRow("Tiempo estimado", "≈ 10 Min"),
              SizedBox(height: 20),

              // Botón
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 14),
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
