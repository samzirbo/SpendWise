import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spend_wise/ui/Home.dart';
import '../view_model/TransactionViewModel.dart';// Update the import path

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionViewModel(),
      child: MaterialApp(
        title: 'SpendWise',
        home: HomeScreen(),
      ),
    ),
  );
}
