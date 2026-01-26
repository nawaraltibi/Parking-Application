/// Payment Request
/// Request body for payment success/failure
class PaymentRequest {
  final double amount;
  final String paymentMethod; // 'cash', 'credit', 'online'
  final String? transactionId;

  const PaymentRequest({
    required this.amount,
    required this.paymentMethod,
    this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_method': paymentMethod,
      if (transactionId != null) 'transaction_id': transactionId,
    };
  }

  factory PaymentRequest.fromJson(Map<String, dynamic> json) {
    return PaymentRequest(
      amount: (json['amount'] is int)
          ? (json['amount'] as int).toDouble()
          : json['amount'] as double,
      paymentMethod: json['payment_method'] as String,
      transactionId: json['transaction_id'] as String?,
    );
  }
}

