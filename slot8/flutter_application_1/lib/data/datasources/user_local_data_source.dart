import 'package:flutter_application_1/core/database/app_database.dart';
import 'package:flutter_application_1/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserLocalDataSource {
  UserLocalDataSource(this._appDatabase);

  final AppDatabase _appDatabase;

  Future<Database> get _db => _appDatabase.database;

  Future<UserModel> findByUsernameAndPassword(required String username, required String password) async {
    final db = await _db;
    final result = await db.query(
      AppDatabase.usersTable,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    } else {
      throw Exception('User not found');
    }
  }

  Future<bool> isUsernameExists({required String username, int? exceptId}) async{
    final db = await _db;
    final result = await db.query(
      AppDatabase.usersTable,
      columns: ['id'],
      where: exceptId == null ? 'username = ?' : 'username = ? AND id != ?',
      whereArgs: exceptId == null ? [username] : [username, exceptId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<UserModel>> getUser() async{
    final db = await _db;
    final result = await db.query(
      AppDatabase.usersTable,
      orderBy: 'id DESC',
    );
    return result.map(UserModel.fromMap).toList();
  }

  Future<UserModel?> getUserById(int id) async{
    final db = await _db;
    final result = await db.query(
      AppDatabase.usersTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if(result.isNotEmpty){
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user)async{
    final db = await _db;
    final values = user.toMap();

    if(user.password.trim().isEmpty){
      values.remove('password');
    }
  values.remove('created_at');
  values.remove('id');
    return await db.update(
      AppDatabase.usersTable,
      values,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  } 

  Future<int> deleteUser(int id)async{
    final db = await _db;
    return await db.delete(
      AppDatabase.usersTable,
      where: 'id = ?',
      whereArgs: [id],
    );
   }
}
