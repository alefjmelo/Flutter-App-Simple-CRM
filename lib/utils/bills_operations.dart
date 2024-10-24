import '../models/clientbill_model.dart';
import 'bills_database.dart';

// Insert a new bill
Future<void> addBill(
    int clientCode, String description, double value, String date) async {
  Bill bill = Bill(
    clientCode: clientCode,
    description: description,
    value: value,
    date: date,
  );
  await BillDatabaseHelper().insertBill(bill);
}

// Retrieve all bills for a specific client
Future<List<Bill>> fetchBillsForClient(int clientCode) async {
  return await BillDatabaseHelper().getBillsForClient(clientCode);
}

// Update an existing bill
Future<void> modifyBill(Bill bill) async {
  await BillDatabaseHelper().updateBill(bill);
}

// Delete a bill
Future<void> removeBill(int clientCode, String description, String date) async {
  await BillDatabaseHelper().deleteBill(clientCode, description, date);
}

// Delete all bills
Future<void> removeAllBillsForClient(int clientCode) async {
  await BillDatabaseHelper().deleteAllBillsForClient(clientCode);
}
