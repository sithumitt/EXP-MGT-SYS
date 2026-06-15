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

  double get remaining => cashInHand - expense;

  factory ExpenseRecord.fromJson(Map<String, dynamic> json) {
    return ExpenseRecord(
      id: json['id'] as String,
      cashInHand: (json['cash_in_hand'] as num).toDouble(),
      expense: (json['expense'] as num).toDouble(),
      date: DateTime.parse(json['created_at'] as String),
    );
  }
}
