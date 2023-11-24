import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/Transaction.dart';
import '../view_model/TransactionViewModel.dart';

class UpdateScreen extends StatelessWidget {
  final Transaction transaction;

  UpdateScreen({required this.transaction});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController nameController =
  TextEditingController(text: transaction.name);
  String? selectedType;
  late TextEditingController amountController =
  TextEditingController(text: transaction.amount.toString());
  late TextEditingController dateController =
  TextEditingController(text: transaction.date);
  late TextEditingController detailsController =
  TextEditingController(text: transaction.details ?? '');

  @override
  Widget build(BuildContext context) {
    selectedType = transaction.type; // Set the initial value

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  onChanged: (value) {
                    selectedType = value;
                  },
                  items: ['Income', 'Expense']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    hintText: 'Select Type',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8), // Adjusted spacing
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty || double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8), // Adjusted spacing
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^\d{1,2}\.\d{1,2}\.\d{4}$').hasMatch(value)) {
                      return 'Please enter a valid date in the format dd.mm.yyyy';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8), // Adjusted spacing
                TextFormField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: 'Details'),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Update the transaction in the list
                        Provider.of<TransactionViewModel>(context, listen: false)
                            .updateTransaction(
                          transaction.id,
                          nameController.text,
                          selectedType!,
                          double.parse(amountController.text),
                          dateController.text,
                          detailsController.text,
                        );

                        // Navigate back to the Home screen
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Set the button background color
                      elevation: 4, // Add elevation for a subtle shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
                      ),
                    ),
                    child: Text('Update Transaction'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
