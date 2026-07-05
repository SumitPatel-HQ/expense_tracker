
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/category.dart';

class ExpenseProvider extends ChangeNotifier {
  
  late final ExpenseDatabase _database;
  final List<Expense> _expenses = [];
  bool _isLoading = false;

  // sort and filters

  String _searchQuery = "";
  Category? _categoryFilter;
  String _sortBy = "date";
  bool _sortAscending = false;

  // Getters

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  Category? get categoryFilter => _categoryFilter;
  String get sortBy => _sortBy;
  bool get sortAscending => _sortAscending;
  List<Expense> get expenses =>_filteredAndSorted();

  List<Category> get categories {
    final Set<Category> categorySet = _expenses.map((e) => e.category).toSet();
    return categorySet.toList();
  }

  // database functions
  ExpenseProvider ({ExpenseDatabase? database})
  {_database =  database ?? ExpenseDatabase.instance;
  }

  Future <void> loadExpense() async{
    _isLoading = true;
    notifyListeners();

    final data = await _database.fetchExpenses();
    _expenses.clear();
    _expenses.addAll(data);

    _isLoading = false;
    notifyListeners();
  }

  Future <void> addExpense(Expense expense) async {
    final id = await _database.insertExpense(expense);
    _expenses.add(expense.copyWith(id: id));
    notifyListeners();
  }

  Future <void> updateExpense(Expense expense) async {
    await _database.updateExpense(expense);
    final index = _expenses.indexWhere((e) => e.id == expense.id);

    if(index != -1)
    {
      _expenses[index] = expense;
      notifyListeners();
    }
  }

  Future <void> deleteExpense(int id) async {
    await _database.deleteExpense(id);
    _expenses.removeWhere((expense)=> expense.id == id);
    notifyListeners();
  }
 
 //filtering

List<Expense>_filteredAndSorted(){
  List<Expense> result = _expenses;

  if(_searchQuery.isNotEmpty)
  {
    final query = _searchQuery.toLowerCase().trim();
    result = result.where((expense){
      return expense.title.toLowerCase().contains(query) ||
      expense.category.displayName.toLowerCase().contains(query) ||
      (expense.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  if(_categoryFilter != null )
  {
    result = result.where((expense) => expense.category == _categoryFilter).toList();
  }

  result.sort((a,b){

    int comparison = 0;
    if(_sortBy == "date"){
      comparison = a.date.compareTo(b.date);
    }

    else if(_sortBy == "amount"){
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

  void setSortBy(String sortBy) {
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
    _sortBy = 'date';
    _sortAscending = false;
    notifyListeners();
  }

  double get totalSpend {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}