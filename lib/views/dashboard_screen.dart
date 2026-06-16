// Purpose: The main dashboard where users can view, add, edit, and delete expenses using MVVM.
import 'package:flutter/material.dart';
import '../models/expense_record.dart';
import '../viewmodels/dashboard_viewmodel.dart';
import 'welcome_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  @override
  // Runs when screen loads. Initializes the ViewModel.
  void initState() {
    super.initState();
    _viewModel = DashboardViewModel();
  }

  @override
  // Cleans up memory when screen closes.
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  // Saves a new expense record to the database.
  Future<void> _addRecord() async {
    if (_formKey.currentState!.validate()) {
      await _viewModel.addRecord();
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  // Opens a popup to edit an existing expense record.
  void _showEditDialog(ExpenseRecord record) {
    final editCashController = TextEditingController(
      text: record.cashInHand.toString(),
    );
    final editExpenseController = TextEditingController(
      text: record.expense.toString(),
    );
    final editFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Record"),
          content: Form(
            key: editFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: editCashController,
                  decoration: const InputDecoration(labelText: 'Cash in Hand'),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter amount';
                    if (double.tryParse(val) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: editExpenseController,
                  decoration: const InputDecoration(
                    labelText: 'Usual Expenses',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Enter amount';
                    if (double.tryParse(val) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (editFormKey.currentState!.validate()) {
                  final cash = double.tryParse(editCashController.text) ?? 0.0;
                  final expense = double.tryParse(editExpenseController.text) ?? 0.0;
                  await _viewModel.updateRecord(record.id, cash, expense);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Opens a popup to confirm deleting an expense record.
  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Record"),
          content: const Text("Are you sure you want to delete this record?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _viewModel.deleteRecord(id);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  // Builds the dashboard UI with input forms and the list of records.
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Expense Dashboard"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () async {
                  await _viewModel.signOut();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.deepPurple.shade50,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _viewModel.cashController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Your Cash in Hand',
                          border: OutlineInputBorder(),
                          prefixText: 'Rs. ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Cannot be empty';
                          if (double.tryParse(val) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _viewModel.expenseController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Your Usual Expenses',
                          border: OutlineInputBorder(),
                          prefixText: 'Rs. ',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) return 'Cannot be empty';
                          if (double.tryParse(val) == null) {
                            return 'Enter a valid number';
                          }
                          return null;
                        },
                      ),
                      if (_viewModel.showRemaining)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            "Rs. ${_viewModel.currentRemaining.toStringAsFixed(2)} will be left for you.",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      if (_viewModel.isLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        ElevatedButton.icon(
                          onPressed: _addRecord,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Record"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _viewModel.getRecordsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    final records =
                        snapshot.data
                            ?.map((e) => ExpenseRecord.fromJson(e))
                            .toList() ??
                        [];

                    if (records.isEmpty) {
                      return const Center(child: Text("No records added yet."));
                    }

                    return ListView.builder(
                      itemCount: records.length,
                      itemBuilder: (context, index) {
                        final record = records[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              "Remaining: Rs. ${record.remaining.toStringAsFixed(2)}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Cash: Rs. ${record.cashInHand} | Expense: Rs. ${record.expense}\nDate: ${record.date.toLocal().toString().substring(0, 16)}",
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showEditDialog(record),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(record.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
