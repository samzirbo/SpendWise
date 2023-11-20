
// update_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Transaction.dart';
import '../view_model/TransactionViewModel.dart';

class UpdateScreen extends StatelessWidget {
  final Transaction transaction;

  UpdateScreen({required this.transaction});

  final TextEditingController nameController =
  TextEditingController(text: transaction.name);
  final TextEditingController typeController =
  TextEditingController(text: transaction.type);
  final TextEditingController amountController =
  TextEditingController(text: transaction.amount.toString());
  final TextEditingController dateController =
  TextEditingController(text: transaction.date);
  final TextEditingController detailsController =
  TextEditingController(text: transaction.details ?? '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(labelText: 'Details'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Update the transaction in the list
                Provider.of<TransactionViewModel>(context, listen: false)
                    .updateTransaction(
                  transaction.id,
                  nameController.text,
                  typeController.text,
                  double.parse(amountController.text),
                  dateController.text,
                  detailsController.text,
                );

                // Navigate back to the Home screen
                Navigator.pop(context);
              },
              child: Text('Update Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
