import 'dart:async';
import 'package:pontodofrango/models/client_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ClientDataBase {
  static final ClientDataBase _instance = ClientDataBase._internal();
  factory ClientDataBase() => _instance;
  static Database? _database;

  ClientDataBase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'client_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clients(
        code INTEGER PRIMARY KEY,
        nome TEXT,
        numero TEXT,
        endereco TEXT
      )
    ''');
  }

  Future<int> insertClient(Client client) async {
    Database db = await database;
    return await db.insert('clients', client.toMap());
  }

  Future<List<Client>> getClients() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('clients');
    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }

  Future<int> updateClient(Client client) async {
    Database db = await database;
    return await db.update(
      'clients',
      client.toMap(),
      where: 'code = ?',
      whereArgs: [client.code],
    );
  }

  Future<int> deleteClient(int code) async {
    Database db = await database;
    return await db.delete(
      'clients',
      where: 'code = ?',
      whereArgs: [code],
    );
  }
}