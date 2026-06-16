import 'package:flutter/material.dart';
import '../services/database_service.dart';

// Purpose: Viewmodel for DashboardScreen handling screen state and CRUD logic.
class DashboardViewModel extends ChangeNotifier {
  final _dbService = DatabaseService();
  final cashController = TextEditingController();
  final expenseController = TextEditingController();

  double _currentRemaining = 0.0;
  bool _showRemaining = false;
  bool _isLoading = false;

  double get currentRemaining => _currentRemaining;
  bool get showRemaining => _showRemaining;
  bool get isLoading => _isLoading;

  DashboardViewModel() {
    cashController.addListener(_calculateRealtime);
    expenseController.addListener(_calculateRealtime);
  }

  // Calculates the remaining balance instantly when user types.
  void _calculateRealtime() {
    final cash = double.tryParse(cashController.text) ?? 0.0;
    final expense = double.tryParse(expenseController.text) ?? 0.0;
    _currentRemaining = cash - expense;
    _showRemaining = cashController.text.isNotEmpty;
    notifyListeners();
  }

  // Saves a new expense record to the database.
  Future<bool> addRecord() async {
    final cash = double.tryParse(cashController.text) ?? 0.0;
    final expense = double.tryParse(expenseController.text) ?? 0.0;

    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.addRecord(cash, expense);
      cashController.clear();
      expenseController.clear();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Updates an existing expense in the database.
  Future<bool> updateRecord(String id, double cash, double expense) async {
    try {
      await _dbService.updateRecord(id, cash, expense);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Deletes an expense from the database.
  Future<bool> deleteRecord(String id) async {
    try {
      await _dbService.deleteRecord(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Gets a live stream of expense records from the database.
  Stream<List<Map<String, dynamic>>> getRecordsStream() {
    return _dbService.getRecordsStream();
  }

  // Logs the user out.
  Future<void> signOut() {
    return _dbService.signOut();
  }

  @override
  void dispose() {
    cashController.removeListener(_calculateRealtime);
    expenseController.removeListener(_calculateRealtime);
    cashController.dispose();
    expenseController.dispose();
    super.dispose();
  }
}
