import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Transaction.dart';
import '../view_model/TransactionViewModel.dart';// Update the import path

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionViewModel(),
      child: MaterialApp(
        title: 'Your App',
        home: TransactionScreen(),
      ),
    ),
  );
}


class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Consumer<TransactionViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            itemCount: viewModel.uiState.transactions.length,
            itemBuilder: (context, index) {
              var transaction = viewModel.uiState.transactions[index];
              return ListTile(
                title: Text(transaction.name),
                subtitle: Text('${transaction.amount} ${transaction.type}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can navigate to a screen or show a dialog to add a new transaction
          // For simplicity, let's use showDialog in this example
          showDialog(
            context: context,
            builder: (context) => AddTransactionDialog(),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


class AddTransactionDialog extends StatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: 'Details'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Call the addTransaction method in the ViewModel
            Provider.of<TransactionViewModel>(context, listen: false).addTransaction(
              nameController.text,
              typeController.text,
              double.tryParse(amountController.text) ?? 0.0,
              dateController.text,
              detailsController.text,
            );

            Navigator.pop(context);
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
