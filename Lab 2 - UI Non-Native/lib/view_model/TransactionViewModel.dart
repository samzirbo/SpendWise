// transaction_view_model.dart
import 'package:flutter/material.dart';
import '../model/Transaction.dart';

class TransactionUIState {
  List<Transaction> transactions;

  TransactionUIState({
    this.transactions = const [],
  });
}

class TransactionViewModel extends ChangeNotifier {
  TransactionUIState _uiState = TransactionUIState();
  TransactionUIState get uiState => _uiState;

  TransactionViewModel() {
    print("TransactionViewModel init");
    _uiState = TransactionUIState(
      transactions: Transaction.init(),
    );
  }

  List<Transaction> get transactions => _uiState.transactions;

  void addTransaction(String name, String type, double amount, String date, String? details) {
    // Find the maximum ID currently in use
    int maxId = _uiState.transactions.fold(0, (max, transaction) => transaction.id > max ? transaction.id : max);
    int newId = maxId + 1;

    // Create a new Transaction with the provided parameters and the updated ID
    Transaction transaction = Transaction(newId, name, type, amount, date, details);

    // Update the transactions list
    _uiState = _uiState.copyWith(
      transactions: [..._uiState.transactions, transaction],
    );

    print("Added -> $transaction");
    notifyListeners();
  }


  void deleteTransaction(int id) {
    // Find the transaction to be deleted
    Transaction deletedTransaction = _uiState.transactions.firstWhere((transaction) => transaction.id == id, orElse: () => throw Exception('Transaction not found'));

    // Update the transactions list by excluding the transaction with the specified ID
    _uiState = _uiState.copyWith(
      transactions: _uiState.transactions.where((transaction) => transaction.id != id).toList(),
    );

    print("Deleted -> $deletedTransaction");
    notifyListeners();
  }


  void updateTransaction(int id, String name, String type, double amount, String date, String? details) {
    Transaction existingTransaction = _uiState.transactions.firstWhere((transaction) => transaction.id == id, orElse: () => throw Exception('Transaction not found'));

    Transaction updatedTransaction = existingTransaction.copyWith(
      name: name,
      type: type,
      amount: amount,
      date: date,
      details: details,
    );

    _uiState = _uiState.copyWith(
      transactions: _uiState.transactions.map((transaction) => transaction.id == id ? updatedTransaction : transaction).toList(),
    );
    print("Updated -> $updatedTransaction");
    notifyListeners();
  }


  String printTransactions() {
    var string = "";
    for (var transaction in _uiState.transactions) {
      string += "$transaction\n";
    }
    return string;
  }
}

extension CopyWithExtension on TransactionUIState {
  TransactionUIState copyWith({
    List<Transaction>? transactions,
  }) {
    return TransactionUIState(
      transactions: transactions ?? this.transactions,
    );
  }
}