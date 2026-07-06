import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/database/app_database.dart';
import 'package:expense_tracker/models/user_profile.dart';

class UserDatabase {
  UserDatabase._();
  
  static final UserDatabase instance = UserDatabase._();

  Future<UserProfile?> fetchProfile() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query(
      'user_profile',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserProfile.fromMap(rows.first);
  }

  Future<int> saveProfile(UserProfile profile) async {
    final db = await AppDatabase.instance.database;
    final data = profile.toMap();
    data['id'] = 1;
    return db.insert(
      'user_profile',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
