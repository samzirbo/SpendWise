// home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_wise/ui/widgets/TransactionList.dart';

import 'Add.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
      ),
      body: TransactionList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
