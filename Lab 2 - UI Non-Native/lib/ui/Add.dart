// add_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Transaction.dart';
import '../view_model/TransactionViewModel.dart';

class AddScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
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
                Provider.of<TransactionViewModel>(context, listen: false)
                    .addTransaction(nameController.text,
                                    typeController.text,
                                    double.parse(amountController.text),
                                    dateController.text,
                                    detailsController.text,
                    );
                Navigator.pop(context);
              },
              child: Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
