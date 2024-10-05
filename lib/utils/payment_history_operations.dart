import '../models/paymenthistory_model.dart';
import 'payment_history_database.dart';

// Insert a new payment history record
Future<void> addPaymentHistory(int clientCode, DateTime paymentDate,
    double totalBill, double amountPaid) async {
  double debit = 0;
  double credit = 0;

  if (amountPaid > totalBill) {
    credit = amountPaid - totalBill;
  } else {
    debit = totalBill - amountPaid;
  }

  PaymentHistory paymentHistory = PaymentHistory(
    clientCode: clientCode,
    paymentDate: paymentDate,
    totalBill: totalBill,
    amountPaid: amountPaid,
    debit: debit,
    credit: credit,
  );

  await PaymentHistoryDatabase.instance
      .insertPaymentHistory(paymentHistory.toMap());
}

// Retrieve all payment history records
Future<List<PaymentHistory>> fetchAllPaymentHistories() async {
  final List<Map<String, dynamic>> maps =
      await PaymentHistoryDatabase.instance.queryAllRows();
  return List.generate(maps.length, (i) {
    return PaymentHistory.fromMap(maps[i]);
  });
}

// Update an existing payment history record
Future<void> modifyPaymentHistory(PaymentHistory paymentHistory) async {
  await PaymentHistoryDatabase.instance
      .updatePaymentHistory(paymentHistory.toMap());
}

// Delete a payment history record
Future<void> removePaymentHistory(int id) async {
  await PaymentHistoryDatabase.instance.deletePaymentHistory(id);
}
