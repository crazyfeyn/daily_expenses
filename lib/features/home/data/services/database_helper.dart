import 'dart:convert';
import 'package:flutter_application/features/home/data/models/expanse_model.dart';
import 'package:flutter_application/features/home/data/models/general_model.dart';
import 'package:flutter_application/features/home/data/models/income.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> _initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'general2.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE general(
          username TEXT PRIMARY KEY,
          totalSalary REAL,
          expanseList TEXT, 
          incomeList TEXT   
        )
        ''');
        await db.execute('''
        CREATE TABLE expanse(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          name TEXT,
          amount REAL,
          dateTime TEXT
        )
        ''');
        await db.execute('''
        CREATE TABLE income(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          name TEXT,
          amount REAL,
          dateTime TEXT
        )
        ''');
      },
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<void> insertGeneral(GeneralModel general) async {
    final db = await database;
    await db.insert(
      'general',
      general.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<GeneralModel?> getGeneral(String username) async {
    final db = await database;

    final generalData = await db.query(
      'general',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (generalData.isEmpty) return null;

    final expanseData = await db.query(
      'expanse',
      where: 'username = ?',
      whereArgs: [username],
    );

    final incomeData = await db.query(
      'income',
      where: 'username = ?',
      whereArgs: [username],
    );

    return GeneralModel.fromMap({
      ...generalData.first,
      'expanseList': jsonEncode(expanseData.map((e) => ExpanseModel.fromMap(e).toMap()).toList()),
      'incomeList': jsonEncode(incomeData.map((i) => Income.fromMap(i).toMap()).toList()),
    });
  }

  Future<void> updateGeneral(GeneralModel general) async {
    final db = await database;

    await db.update(
      'general',
      general.toMap(),
      where: 'username = ?',
      whereArgs: [general.username],
    );
  }

  Future<void> deleteGeneral(String username) async {
    final db = await database;

    await db.delete(
      'general',
      where: 'username = ?',
      whereArgs: [username],
    );

    await db.delete(
      'expanse',
      where: 'username = ?',
      whereArgs: [username],
    );

    await db.delete(
      'income',
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<void> insertExpense(ExpanseModel expense) async {
    final db = await database;
    await db.insert(
      'expanse',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ExpanseModel>> getExpenses(String username) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expanse',
      where: 'username = ?',
      whereArgs: [username],
    );
    return List.generate(maps.length, (i) {
      return ExpanseModel.fromMap(maps[i]);
    });
  }
}
