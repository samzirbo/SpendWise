// transaction_list_view.dart
// ...

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/Transaction.dart';
import '../../view_model/TransactionViewModel.dart';
import '../Update.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        List<Transaction> transactions = viewModel.transactions;

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            Transaction transaction = transactions[index];

            return ListTile(
              title: Text(transaction.name),
              subtitle: Text('${transaction.amount} ${transaction.type}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Show a confirmation dialog for delete
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Transaction'),
                      content: Text('Are you sure you want to delete this transaction?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Delete the transaction and close the dialog
                            viewModel.deleteTransaction(transaction.id);
                            Navigator.pop(context);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              onTap: () {
                // Navigate to the UpdateScreen with the selected transaction
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateScreen(transaction: transaction),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
