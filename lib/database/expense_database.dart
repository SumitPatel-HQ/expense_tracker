import 'package:sqflite/sqflite.dart';
import 'package:expense_tracker/database/app_database.dart';
import 'package:expense_tracker/models/expense.dart';
class ExpenseDatabase {

  ExpenseDatabase._();
  static final ExpenseDatabase instance = ExpenseDatabase._();
  Future<List<Expense>> fetchExpenses() async {
    final db = await AppDatabase.instance.database;
    final rows = await db.query('expenses', orderBy: 'date DESC');
    return rows.map(Expense.fromMap).toList();
  }

  Future<int> insertExpense(Expense expense) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await AppDatabase.instance.database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }
  
  Future<int> deleteExpense(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
