enum CurrencyType { fiat, crypto }

class Currency {
  final CurrencyType type;
  final String id;
  final String code;
  final String symbol;
  final String name;
  final String flagPath;

  const Currency({
    required this.type,
    required this.id,
    required this.code,
    required this.symbol,
    required this.name,
    required this.flagPath,
  });
}
