import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_exchange/services/calculator/get_currency_list.dart';
import 'package:flutter_exchange/models/currency.dart';
import 'package:dio/dio.dart';
part 'currency_calculator_state.g.dart';

//
// Listado de todas las monedas divididas en fiat y crypto
//
class CurrencyListState {
  final List<Currency> fiatCurrencies;
  final List<Currency> cryptoCurrencies;
  final bool isLoading;
  CurrencyListState({required this.fiatCurrencies, required this.cryptoCurrencies, this.isLoading = false});
}

@Riverpod(keepAlive: true)
class CurrencyList extends _$CurrencyList {
  @override
  CurrencyListState build() {
    return CurrencyListState(fiatCurrencies: [], cryptoCurrencies: [], isLoading: false);
  }

  Future<void> fetchCurrencies() async {
    state = CurrencyListState(
      fiatCurrencies: state.fiatCurrencies,
      cryptoCurrencies: state.cryptoCurrencies,
      isLoading: true,
    );

    final currencies = await CurrencyService.getCurrencyList();
    final fiatCurrencies = currencies.where((c) => c.type == CurrencyType.fiat).toList();
    final cryptoCurrencies = currencies.where((c) => c.type == CurrencyType.crypto).toList();

    if (currencies.isNotEmpty) {
      final from = fiatCurrencies.first;
      final to = cryptoCurrencies.first;
      ref.read(selectedCurrencyProvider.notifier).setBoth(from, to);
    }

    state = CurrencyListState(fiatCurrencies: fiatCurrencies, cryptoCurrencies: cryptoCurrencies, isLoading: false);
  }
}

//
// Estado de las monedas seleccionadas
//
class SelectedCurrencyState {
  final Currency from;
  final Currency to;
  SelectedCurrencyState({required this.from, required this.to});
}

@riverpod
class SelectedCurrency extends _$SelectedCurrency {
  @override
  SelectedCurrencyState build() {
    return SelectedCurrencyState(
      from: Currency(type: CurrencyType.fiat, code: "", name: "", flagPath: "", symbol: ''),
      to: Currency(type: CurrencyType.fiat, code: "", name: "", flagPath: "", symbol: ''),
    );
  }

  void setFrom(Currency currency) {
    state = SelectedCurrencyState(from: currency, to: state.to);
  }

  void setTo(Currency currency) {
    state = SelectedCurrencyState(to: currency, from: state.from);
  }

  void setBoth(Currency from, Currency to) {
    state = SelectedCurrencyState(from: from, to: to);
  }

  void toggle() {
    final temp = state.from;
    state = SelectedCurrencyState(from: state.to, to: temp);
  }
}

//
// Verifica si los datos necesarios para el cálculo están listos
//
@riverpod
bool isDataready(ref) {
  final currencyList = ref.watch(currencyListProvider);
  final selectedCurrencies = ref.watch(selectedCurrencyProvider);

  return !currencyList.isLoading &&
      currencyList.fiatCurrencies.isNotEmpty &&
      currencyList.cryptoCurrencies.isNotEmpty &&
      selectedCurrencies.from.code.isNotEmpty &&
      selectedCurrencies.to.code.isNotEmpty;
}

//
// Controla el input del monto y realiza el cálculo de la conversión
//
class ConvertionResult {
  final double amount;
  final double estimatedRate;
  final double convertedAmount;
  final int time;
  final bool isLoading;
  const ConvertionResult({
    required this.amount,
    required this.estimatedRate,
    required this.convertedAmount,
    required this.time,
    this.isLoading = false,
  });
}

@riverpod
class AmountInput extends _$AmountInput {
  static const ConvertionResult _initialValue = ConvertionResult(
    amount: 5,
    estimatedRate: 0.0,
    convertedAmount: 0.0,
    time: 10,
    isLoading: false,
  );

  @override
  ConvertionResult build() {
    return _initialValue;
  }

  void update(String input) async {
    if (input.isEmpty) {
      state = _initialValue;
      return;
    }

    final value = double.tryParse(input) ?? 0;

    final fromCurrency = ref.read(selectedCurrencyProvider).from;
    final toCurrency = ref.read(selectedCurrencyProvider).to;

    final fromType = fromCurrency.type;
    final criptoCurrencyId = fromType == CurrencyType.crypto ? fromCurrency.code : toCurrency.code;
    final fiatCurrencyId = fromType == CurrencyType.fiat ? fromCurrency.code : toCurrency.code;

    final queryParams = {
      'type': fromType == CurrencyType.crypto ? 0 : 1,
      'cryptoCurrencyId': criptoCurrencyId,
      'fiatCurrencyId': fiatCurrencyId,
      'amount': value.abs(),
      'amountCurrencyId': fromCurrency.code,
    };

    print(queryParams);

    try {
      final response = await Dio().get(
        'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations',
        queryParameters: queryParams,
      );
      print(response.data?.byPrice.toString());
    } catch (e) {
      print("Error fetching conversion data: $e");
      state = ConvertionResult(amount: value, estimatedRate: 0.0, convertedAmount: 0.0, time: 10, isLoading: false);
      return;
    }
  }
}
