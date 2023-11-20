

class Transaction {

  static List<Transaction> init() {
    return [
      Transaction(1, "Transaction 1", "Income", 100.0, "2023-10-12", "Details 1"),
      Transaction(2, "Transaction 2", "Expense", 50.0, "2023-10-12", "Details 2"),
      Transaction(3, "Transaction 3", "Income", 200.0, "2023-10-13", "Details 3"),
      Transaction(4, "Transaction 4", "Expense", 30.0, "2023-10-14", "Details 4"),
      Transaction(5, "Transaction 5", "Income", 150.0, "2023-10-15", "Details 5")
    ];
  }

  final int id;
  String name;
  String type;
  double amount;
  String date;
  String? details;

  Transaction(this.id, this.name, this.type, this.amount, this.date, this.details);
  Transaction.fromTransaction(this.id, this.name, this.type, this.amount, this.date, this.details);

  Transaction copyWith({required String name, required String type, required double amount, required String date, String? details}) {
    return Transaction.fromTransaction(this.id, name, type, amount, date, details);
  }

  @override
  String toString() {
    return "Transaction(id: $id, name: $name, type: $type, amount: $amount, date: $date, details: $details)";
  }
}