import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category.dart';

enum SortOption {
  date,
  amount,
}

class ExpenseProvider extends ChangeNotifier {
  late final ExpenseDatabase _database;
  final List<Expense> _expenses = [];
  bool _isLoading = false;
  String _error = '';

  // Sort and filter state
  String _searchQuery = '';
  Category? _categoryFilter;
  bool _sortAscending = false;
  SortOption _sortBy = SortOption.date;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get searchQuery => _searchQuery;
  Category? get categoryFilter => _categoryFilter;
  SortOption get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;


  List<Expense> get expenses => _filteredAndSorted();


  List<Category> get categories {
    final Set<Category> categorySet = _expenses.map((e) => e.category).toSet();
    return categorySet.toList();
  }
.
  double get totalSpend {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  ExpenseProvider({ExpenseDatabase? database})
      : _database = database ?? ExpenseDatabase.instance;


  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _database.fetchExpenses();
      _expenses
        ..clear()
        ..addAll(data);
    } catch (e) {
      _error = 'Failed to load expenses: $e';
      debugPrint('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      final id = await _database.insertExpense(expense);
      _expenses.add(expense.copyWith(id: id));
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add expense: $e';
      debugPrint('Error adding expense: $e');
      notifyListeners();
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _database.updateExpense(expense);
      final index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update expense: $e';
      debugPrint('Error updating expense: $e');
      notifyListeners();
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _database.deleteExpense(id);
      _expenses.removeWhere((expense) => expense.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete expense: $e';
      debugPrint('Error deleting expense: $e');
      notifyListeners();
    }
  }

  List<Expense> _filteredAndSorted() {
    List<Expense> result = List<Expense>.from(_expenses);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      result = result.where((expense) {
        return expense.title.toLowerCase().contains(query) ||
            expense.category.displayName.toLowerCase().contains(query) ||
            (expense.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (_categoryFilter != null) {
      result =
          result.where((expense) => expense.category == _categoryFilter).toList();
    }

    result.sort((a, b) {
      int comparison = 0;
      if (_sortBy == SortOption.date) {
        comparison = a.date.compareTo(b.date);
      } else if (_sortBy == SortOption.amount) {
        comparison = a.amount.compareTo(b.amount);
      }
      return _sortAscending ? comparison : -comparison;
    });

    return result;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setCategoryFilter(Category? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void clearCategoryFilter() {
    _categoryFilter = null;
    notifyListeners();
  }

  void setSortBy(SortOption sortBy) {
    if (_sortBy == sortBy) {
      _sortAscending = !_sortAscending;
    } else {
      _sortBy = sortBy;
      _sortAscending = false;
    }
    notifyListeners();
  }

  void toggleSortOrder() {
    _sortAscending = !_sortAscending;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _categoryFilter = null;
    _sortBy = SortOption.date;
    _sortAscending = false;
    notifyListeners();
  }
}