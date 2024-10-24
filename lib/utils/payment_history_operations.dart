import '../models/paymenthistory_model.dart';
import 'payment_history_database.dart';

// Insert a new payment history record
Future<void> addPaymentHistory(int clientCode, String paymentDate,
    double totalBill, double amountPaid) async {
  PaymentHistory paymentHistory = PaymentHistory(
    clientCode: clientCode,
    paymentDate: paymentDate,
    totalBill: totalBill,
    amountPaid: amountPaid,
  );

  await PaymentHistoryDatabase.instance
      .insertPaymentHistory(paymentHistory.toMap());
}

// Retrieve all payment history records for a client
Future<List<PaymentHistory>> fetchPaymentHistoryByClient(int clientCode) async {
  final List<Map<String, dynamic>> maps = await PaymentHistoryDatabase.instance
      .getPaymentHistoryForClient(clientCode);
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
