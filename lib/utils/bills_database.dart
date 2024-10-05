import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/clientbill_model.dart';

class BillDatabaseHelper {
  static final BillDatabaseHelper _instance = BillDatabaseHelper._internal();
  factory BillDatabaseHelper() => _instance;
  static Database? _database;

  BillDatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'bill_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bills(
        clientCode INTEGER,
        description TEXT,
        value REAL,
        date TEXT,
        FOREIGN KEY(clientCode) REFERENCES clients(code)
      )
    ''');
  }

  Future<int> insertBill(Bill bill) async {
    Database db = await database;
    return await db.insert('bills', bill.toMap());
  }

  Future<List<Bill>> getBillsForClient(int clientCode) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bills',
      where: 'clientCode = ?',
      whereArgs: [clientCode],
    );
    return List.generate(maps.length, (i) {
      return Bill.fromMap(maps[i]);
    });
  }

  Future<int> updateBill(Bill bill) async {
    Database db = await database;
    return await db.update(
      'bills',
      bill.toMap(),
      where: 'clientCode = ? AND description = ? AND date = ?',
      whereArgs: [bill.clientCode, bill.description, bill.date],
    );
  }

  Future<int> deleteBill(
      int clientCode, String description, String date) async {
    Database db = await database;
    return await db.delete(
      'bills',
      where: 'clientCode = ? AND description = ? AND date = ?',
      whereArgs: [clientCode, description, date],
    );
  }
}
