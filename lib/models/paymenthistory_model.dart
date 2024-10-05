class PaymentHistory {
  final int clientCode;
  DateTime paymentDate;
  double totalBill;
  double amountPaid;
  double debit;
  double credit;

  PaymentHistory({
    required this.clientCode,
    required this.paymentDate,
    required this.totalBill,
    required this.amountPaid,
    required this.debit,
    required this.credit,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientCode': clientCode,
      'paymentDate': paymentDate.toIso8601String(),
      'totalBill': totalBill,
      'amountPaid': amountPaid,
      'debit': debit,
      'credit': credit,
    };
  }

  factory PaymentHistory.fromMap(Map<String, dynamic> map) {
    return PaymentHistory(
      clientCode: map['clientCode'],
      paymentDate: DateTime.parse(map['paymentDate']),
      totalBill: map['totalBill'],
      amountPaid: map['amountPaid'],
      debit: map['debit'],
      credit: map['credit'],
    );
  }
}
