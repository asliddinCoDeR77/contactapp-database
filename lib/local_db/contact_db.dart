import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertContact(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('contacts', row);
  }

  Future<List<Map<String, dynamic>>> queryAllContacts() async {
    Database db = await database;
    return await db.query('contacts');
  }

  Future<int> updateContact(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row['id'];
    return await db.update('contacts', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }
}
