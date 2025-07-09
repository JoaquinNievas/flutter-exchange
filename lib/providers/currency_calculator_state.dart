import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_exchange/services/calculator/get_currency_list.dart';
import 'package:flutter_exchange/models/index.dart';
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
      final from = cryptoCurrencies.first;
      final to = fiatCurrencies.first;
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
      from: Currency(type: CurrencyType.fiat, code: "", name: "", flagPath: "", symbol: '', id: ''),
      to: Currency(type: CurrencyType.fiat, code: "", name: "", flagPath: "", symbol: '', id: ''),
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

  ConvertionResult copyWith({
    double? amount,
    double? estimatedRate,
    double? convertedAmount,
    int? time,
    bool? isLoading,
  }) {
    return ConvertionResult(
      amount: amount ?? this.amount,
      estimatedRate: estimatedRate ?? this.estimatedRate,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ConversionRequest {
  final String cryptoCurrencyId;
  final String fiatCurrencyId;
  final double amount;
  final String amountCurrencyId;
  final int type; // 0 for crypto, 1 for fiat

  ConversionRequest({
    required this.cryptoCurrencyId,
    required this.fiatCurrencyId,
    required this.amount,
    required this.amountCurrencyId,
    required this.type,
  });

  Map<String, dynamic> toJSON() {
    return {
      'type': type,
      'cryptoCurrencyId': cryptoCurrencyId,
      'fiatCurrencyId': fiatCurrencyId,
      'amount': amount,
      'amountCurrencyId': amountCurrencyId,
    };
  }
}

@Riverpod(keepAlive: true)
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

    final value = (double.tryParse(input) ?? 0).abs();

    state = state.copyWith(amount: value);

    await fetchConversionData();
  }

  Future<void> fetchConversionData() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);
    final currencies = ref.read(selectedCurrencyProvider);
    final fromCurrency = currencies.from;
    final toCurrency = currencies.to;

    final fromType = fromCurrency.type;
    final criptoCurrencyId = fromType == CurrencyType.crypto ? fromCurrency.id : toCurrency.id;
    final fiatCurrencyId = fromType == CurrencyType.fiat ? fromCurrency.id : toCurrency.id;
    final amount = state.amount;

    final request = ConversionRequest(
      cryptoCurrencyId: criptoCurrencyId,
      fiatCurrencyId: fiatCurrencyId,
      amount: amount,
      amountCurrencyId: fromCurrency.id,
      type: fromType == CurrencyType.crypto ? 0 : 1,
    );

    try {
      final response = await Dio().get(
        'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations',
        queryParameters: request.toJSON(),
      );
      final raw = response.data as Map<String, dynamic>;
      final data = raw['data'];
      if (data is! Map || data.isEmpty) throw Exception("No se encontró información");
      final byPrice = data['byPrice'];
      final rawFiatToCryptoExchangeRate = byPrice['fiatToCryptoExchangeRate'];
      final fiatToCryptoExchangeRate = double.tryParse(rawFiatToCryptoExchangeRate);

      if (fiatToCryptoExchangeRate == null || fiatToCryptoExchangeRate.isNaN || fiatToCryptoExchangeRate == 0.0) {
        throw Exception("Ocurrió un error al obtener la tasa de cambio");
      }
      final convertedAmount = request.type == 1
          ? request.amount / fiatToCryptoExchangeRate
          : request.amount * fiatToCryptoExchangeRate;

      state = state.copyWith(
        estimatedRate: fiatToCryptoExchangeRate,
        convertedAmount: double.parse(convertedAmount.toStringAsFixed(2)),
        isLoading: false,
      );
    } catch (e) {
      //TODO: Mostrar snackbar de error
      print("Error fetching conversion data: $e");
      state = ConvertionResult(
        amount: request.amount,
        estimatedRate: 0.0,
        convertedAmount: 0.0,
        time: 10,
        isLoading: false,
      );
    }
  }
}
