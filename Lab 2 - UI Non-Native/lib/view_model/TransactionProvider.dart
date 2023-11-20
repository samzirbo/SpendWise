// transaction_provider.dart
import 'package:flutter/material.dart';
import 'TransactionViewModel.dart';

class TransactionProvider extends InheritedNotifier {
  final TransactionViewModel viewModel = TransactionViewModel();

  TransactionProvider({super.key,
    required TransactionViewModel viewModel,
    required super.child,
  }) : super(notifier: viewModel);

  static TransactionViewModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TransactionProvider>()!
        .viewModel;
  }
}
