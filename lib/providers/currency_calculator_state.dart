import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_exchange/services/calculator/get_currency_list.dart';
import 'package:flutter_exchange/models/currency.dart';

part 'currency_calculator_state.g.dart';

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
