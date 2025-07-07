// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_calculator_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isDatareadyHash() => r'9e02df0024831f2eb12c2f63f960cd000a5cbc0d';

/// See also [isDataready].
@ProviderFor(isDataready)
final isDatareadyProvider = AutoDisposeProvider<bool>.internal(
  isDataready,
  name: r'isDatareadyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isDatareadyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsDatareadyRef = AutoDisposeProviderRef<bool>;
String _$currencyListHash() => r'5d53fc27fc48164087fd73b85fde38aa8b0d4f67';

/// See also [CurrencyList].
@ProviderFor(CurrencyList)
final currencyListProvider =
    NotifierProvider<CurrencyList, CurrencyListState>.internal(
      CurrencyList.new,
      name: r'currencyListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currencyListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrencyList = Notifier<CurrencyListState>;
String _$selectedCurrencyHash() => r'e67b44a8816ca02f66b52409405b8260cefb88a4';

/// See also [SelectedCurrency].
@ProviderFor(SelectedCurrency)
final selectedCurrencyProvider =
    AutoDisposeNotifierProvider<
      SelectedCurrency,
      SelectedCurrencyState
    >.internal(
      SelectedCurrency.new,
      name: r'selectedCurrencyProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedCurrencyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedCurrency = AutoDisposeNotifier<SelectedCurrencyState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
