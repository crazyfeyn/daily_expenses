import 'package:flutter_application/features/auth/data/models/usermodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AuthService {
  Future<Database> openDatabaseFunc() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'auth_service.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, username TEXT, password TEXT)',
        );
      },
    );
  }

  Future<UserModel?> registerUser(
      Database db, String username, String password) async {
    final user = {
      'username': username,
      'password': password,
    };

    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return UserModel(username: username, password: password);
  }

  Future<UserModel?> loginUser(
      Database db, String username, String password) async {
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return UserModel(
          username: result.first['username'],
          password: result.first['password']);
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getUsers(Database db) async {
    return await db.query('users');
  }

  Future<void> updateUserPassword(
      Database db, int id, String newPassword) async {
    await db.update(
      'users',
      {'password': newPassword},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteUser(Database db, int id) async {
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
