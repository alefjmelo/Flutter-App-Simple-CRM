import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PaymentHistoryDatabase {
  static final PaymentHistoryDatabase instance =
      PaymentHistoryDatabase._internal();
  static Database? _database;

  PaymentHistoryDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'payment_history_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE payment_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clientCode INTEGER,
        paymentDate TEXT,
        totalBill REAL,
        amountPaid REAL,
        FOREIGN KEY(clientCode) REFERENCES clients(code)
      )
    ''');
  }

  Future<int> insertPaymentHistory(Map<String, dynamic> payment) async {
    Database db = await database;
    return await db.insert('payment_history', payment);
  }

  Future<List<Map<String, dynamic>>> getPaymentHistoryForClient(
      int clientCode) async {
    Database db = await database;
    return await db.query(
      'payment_history',
      where: 'clientCode = ?',
      whereArgs: [clientCode],
      orderBy: 'paymentDate DESC',
    );
  }

  Future<int> updatePaymentHistory(Map<String, dynamic> payment) async {
    Database db = await database;
    return await db.update(
      'payment_history',
      payment,
      where: 'id = ?',
      whereArgs: [payment['id']],
    );
  }

  Future<int> deletePaymentHistory(int id) async {
    Database db = await database;
    return await db.delete(
      'payment_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
