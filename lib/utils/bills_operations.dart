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

// Delete a bill
Future<void> removeBill(int clientCode, String description, String date) async {
  await BillDatabaseHelper().deleteBill(clientCode, description, date);
}

// Delete all bills
Future<void> removeAllBillsForClient(int clientCode) async {
  await BillDatabaseHelper().deleteAllBillsForClient(clientCode);
}

// Retrieve total amount for the current week
Future<Map<String, double>> getTotalAmountForWeek() async {
  return await BillDatabaseHelper().getTotalAmountForWeek();
}

// Retrieve total amount for a specific month
Future<Map<String, double>> getTotalAmountForMonth(int month) async {
  return await BillDatabaseHelper().getTotalAmountForMonth(month);
}

// Retrieve total amount for a specific year
Future<Map<String, double>> getTotalAmountForYear(int year) async {
  return await BillDatabaseHelper().getTotalAmountForYear(year);
}
