import 'package:flutter/foundation.dart';

class TransactionItem {
  final String id;
  final String type;
  final double amount;
  final String note;
  final String category;
  final DateTime date;

  const TransactionItem({
    required this.id,
    required this.type,
    required this.amount,
    required this.note,
    required this.category,
    required this.date,
  });
}

class ExpenseModel extends ChangeNotifier {
  final List<TransactionItem> _transactions = [];

  double get income => _transactions
      .where((t) => t.type == 'income')
      .fold(0, (s, t) => s + t.amount);

  double get expense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0, (s, t) => s + t.amount);

  double get balance => income - expense;

  List<TransactionItem> get transactions => List.unmodifiable(_transactions);

  final List<String> _incomeCategories = ['Lương', 'Thưởng', 'Khác'];
  final List<String> _expenseCategories = [
    'Ăn uống',
    'Đi lại',
    'Hóa đơn',
    'Mua sắm',
  ];

  List<String> get incomeCategories => List.unmodifiable(_incomeCategories);
  List<String> get expenseCategories => List.unmodifiable(_expenseCategories);

  void addIncomeCategory(String name) {
    if (!_incomeCategories.contains(name)) {
      _incomeCategories.add(name);
      notifyListeners();
    }
  }

  void addExpenseCategory(String name) {
    if (!_expenseCategories.contains(name)) {
      _expenseCategories.add(name);
      notifyListeners();
    }
  }

  void addIncome(
    double amount,
    String note,
    String category, {
    DateTime? date,
  }) {
    _transactions.add(
      TransactionItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'income',
        amount: amount,
        note: note,
        category: category,
        date: date ?? DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addExpense(
    double amount,
    String note,
    String category, {
    DateTime? date,
  }) {
    _transactions.add(
      TransactionItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'expense',
        amount: amount,
        note: note,
        category: category,
        date: date ?? DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void addTransaction({
    required String type,
    required double amount,
    required String note,
    required String category,
    DateTime? date,
  }) {
    if (type == 'income') {
      addIncome(amount, note, category, date: date);
    } else {
      addExpense(amount, note, category, date: date);
    }
  }

  double totalAmount({required String type, String? category}) {
    return _transactions
        .where((t) {
          final matchType = t.type == type;
          final matchCategory = category == null || t.category == category;
          return matchType && matchCategory;
        })
        .fold(0, (sum, t) => sum + t.amount);
  }
}
