import 'package:flutter_exchange/models/currency.dart';

//Simulo un listado de monedas que podrían venir de una API
const List<Currency> currenciesMock = [
  Currency(
    type: CurrencyType.fiat,
    code: "VES",
    symbol: 'Bs',
    name: "Bolívares",
    flagPath: "assets/fiat_currencies/VES.png",
  ),
  Currency(
    type: CurrencyType.fiat,
    code: "COP",
    symbol: 'COL\$',
    name: "Pesos Colombianos",
    flagPath: "assets/fiat_currencies/COP.png",
  ),
  Currency(
    type: CurrencyType.fiat,
    code: "PEN",
    symbol: 'S/',
    name: "Soles Peruanos",
    flagPath: "assets/fiat_currencies/PEN.png",
  ),
  Currency(
    type: CurrencyType.fiat,
    code: "BRL",
    symbol: 'R\$',
    name: "Real Brasileño",
    flagPath: "assets/fiat_currencies/BRL.png",
  ),

  Currency(
    type: CurrencyType.crypto,
    code: "USDT",
    symbol: 'USDT',
    name: "Tether",
    flagPath: "assets/cripto_currencies/TATUM-TRON-USDT.png",
  ),
];

class CurrencyService {
  // Simula una llamada a una API para obtener la lista de monedas
  static Future<List<Currency>> getCurrencyList() async {
    await Future.delayed(Duration(seconds: 1)); // Simulo un retraso de red
    return currenciesMock;
  }
}
