import 'package:expense_tracker/models/category.dart';

class Expense {
  final int? id;
  final String title;
  final String? description;
  final double amount;
  final Category category;
  final DateTime date;

  Expense._({
    this.id, 
    required this.title, 
    this.description, 
    required this.amount, 
    required this.category, 
    required this.date});

  factory Expense({
    int? id, required String title, 
    String? description, 
    required double amount, 
    required Category category, 
    required DateTime date
    }) {
    if (title.trim().isEmpty) throw ArgumentError('Expense title cannot be empty.');
    if (amount < 0) throw ArgumentError('Expense amount cannot be negative.');
    return Expense._(
      id: id, 
      title: title, 
      description: description, 
      amount: amount, 
      category: category, 
      date: date
    );
  }

  Expense copyWith({
    int? id,
    String? title,
    String? description,
    double? amount,
    Category? category,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String?,
      amount: (map['amount'] as num).toDouble(),
      category: Category.fromString(map['category'] as String),
      date: DateTime.parse(map['date'] as String),
    );
  }
}
