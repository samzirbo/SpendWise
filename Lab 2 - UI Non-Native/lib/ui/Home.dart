import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/Transaction.dart';
import '../view_model/TransactionViewModel.dart';
import 'Add.dart';
import 'Update.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List')
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, viewModel, child) {
          List<Transaction> transactions = viewModel.transactions;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              Transaction transaction = transactions[index];

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Add margin for spacing
                child: ListTile(
                  title: Text(
                    transaction.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${transaction.type} | ${transaction.amount} | ${transaction.date}',
                    style: TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Transaction'),
                          content: Text('Are you sure you want to delete this transaction?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateScreen(transaction: transaction),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen, // Set the FAB background color
      ),
    );
  }
}
