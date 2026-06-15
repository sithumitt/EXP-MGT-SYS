// Purpose: Defines the data structure for an expense record.
class ExpenseRecord {
  String id;
  double cashInHand;
  double expense;
  DateTime date;

  ExpenseRecord({
    required this.id,
    required this.cashInHand,
    required this.expense,
    required this.date,
  });

  // Calculates the money left after expenses.
  double get remaining => cashInHand - expense;

  // Converts database JSON data into an ExpenseRecord object.
  factory ExpenseRecord.fromJson(Map<String, dynamic> json) {
    return ExpenseRecord(
      id: json['id'] as String,
      cashInHand: (json['cash_in_hand'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      date: DateTime.parse(json['created_at'] as String),
    );
  }
}
