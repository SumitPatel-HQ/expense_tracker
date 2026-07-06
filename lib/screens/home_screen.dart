import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/screens/profile_screen.dart';
import 'expense_form_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  Category? _selectedCategory;
  SortOption _selectedSort = SortOption.date;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ExpenseProvider>();
    Future.microtask(() => provider.loadExpenses());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToExpenseForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ExpenseFormPage(),
      ),
    );
  }

  void _goToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  void _onBottomTap(int index) {
    if (index == 1) {
      _goToExpenseForm();
    } else if (index == 2) {
      _goToProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = context.watch<ExpenseProvider>();
    final expenses = expenseProvider.expenses;
    final totalExpense = expenseProvider.totalSpend;

    return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Expense Tracker',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: expenseProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        context
                            .read<ExpenseProvider>()
                            .setSearchQuery(value);
                      },
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<Category?>(
                                value: _selectedCategory,
                                isExpanded: true,
                                hint: const Text('All'),
                                items: [
                                  const DropdownMenuItem<Category?>(
                                    value: null,
                                    child: Text('All'),
                                  ),
                                  ...Category.values.map((category) {
                                    return DropdownMenuItem<Category?>(
                                      value: category,
                                      child: Text(
                                        category.name[0].toUpperCase() +
                                            category.name.substring(1),
                                      ),
                                    );
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                  context
                                      .read<ExpenseProvider>()
                                      .setCategoryFilter(value);
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<SortOption>(
                                value: _selectedSort,
                                isExpanded: true,
                                items: SortOption.values.map((sort) {
                                  return DropdownMenuItem(
                                    value: sort,
                                    child: Text(
                                      sort.name[0].toUpperCase() +
                                          sort.name.substring(1),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() {
                                    _selectedSort = value;
                                  });
                                  context
                                      .read<ExpenseProvider>()
                                      .setSortBy(value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Expense',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹ ${totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: expenses.isEmpty
                          ? const Center(
                              child: Text(
                                'No expenses found',
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.separated(
                              itemCount: expenses.length,
                              separatorBuilder:
                                  (context, index) =>
                                      const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final expense = expenses[index];

                                return Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              expense.title,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '₹ ${expense.amount.toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        expense.description ?? '',
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Category: ${expense.category.displayName}',
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Date: ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ExpenseFormPage(
                                                    existingExpense: expense,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.edit),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (expense.id != null) {
                                                context
                                                    .read<ExpenseProvider>()
                                                    .deleteExpense(expense.id!);
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToExpenseForm,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: true,
                onTap: () => _onBottomTap(0),
              ),
              const SizedBox(width: 40),
              _bottomItem(
                icon: Icons.person,
                label: 'Profile',
                isSelected: false,
                onTap: () => _onBottomTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.deepPurple : Colors.grey,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.deepPurple : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}