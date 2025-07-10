//
// Controla el input del monto y realiza el cálculo de la conversión
//
class ConvertionResult {
  final double amount;
  final double estimatedRate;
  final double convertedAmount;
  final int time;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? errorTimestamp;

  const ConvertionResult({
    required this.amount,
    required this.estimatedRate,
    required this.convertedAmount,
    required this.time,
    this.isLoading = false,
    this.errorMessage,
    this.errorTimestamp,
  });

  ConvertionResult copyWith({
    double? amount,
    double? estimatedRate,
    double? convertedAmount,
    int? time,
    bool? isLoading,
    String? errorMessage,
    DateTime? errorTimestamp,
  }) {
    return ConvertionResult(
      amount: amount ?? this.amount,
      estimatedRate: estimatedRate ?? this.estimatedRate,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      time: time ?? this.time,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      errorTimestamp: errorTimestamp ?? this.errorTimestamp,
    );
  }
}
