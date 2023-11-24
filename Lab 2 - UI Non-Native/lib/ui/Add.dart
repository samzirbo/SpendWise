import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/TransactionViewModel.dart';

class AddScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  String? selectedType;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction')
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
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(), // Add a border
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8), // Adjusted spacing
                // DropdownButton for Type
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
                    border: OutlineInputBorder(), // Add a border
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
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(), // Add a border
                  ),
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
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(), // Add a border
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^\d{1,2}\.\d{1,2}\.\d{4}$').hasMatch(value)) {
                      return 'Please enter a valid date in the format dd.mm.yyyy';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<TransactionViewModel>(context, listen: false)
                            .addTransaction(
                          nameController.text,
                          selectedType!,
                          double.parse(amountController.text),
                          dateController.text,
                          detailsController.text,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green, // Set the button background color
                      elevation: 4, // Add elevation for a subtle shadow
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Add rounded corners
                      ),
                    ),
                    child: const Text('Add Transaction'),
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
