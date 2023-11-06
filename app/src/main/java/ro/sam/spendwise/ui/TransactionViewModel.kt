package ro.sam.spendwise.ui

import androidx.lifecycle.ViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import ro.sam.spendwise.data.Transaction
import ro.sam.spendwise.data.TransactionCategory
import ro.sam.spendwise.data.TransactionType
import java.util.Date

class TransactionViewModel: ViewModel() {

    private val _uiState = MutableStateFlow(TransactionUIState())
    val uiState: StateFlow<TransactionUIState> = _uiState.asStateFlow()

    init {
        _uiState.value = TransactionUIState(
            transactions = mutableListOf<Transaction>(
                Transaction(1, "Transaction 1", "Income", 100.0, "2023-10-12", "Details 1"),
                Transaction(2, "Transaction 2", "Expense", 50.0, "2023-10-12", "Details 2"),
                Transaction(3, "Transaction 3", "Income", 200.0, "2023-10-13", "Details 3"),
                Transaction(4, "Transaction 4", "Expense", 30.0, "2023-10-14", "Details 4"),
                Transaction(5, "Transaction 5", "Income", 150.0, "2023-10-15", "Details 5"),
                Transaction(6, "Transaction 6", "Expense", 75.0, "2023-10-16", "Details 6"),
                Transaction(7, "Transaction 7", "Income", 120.0, "2023-10-17", "Details 7"),
                Transaction(8, "Transaction 8", "Expense", 20.0, "2023-10-18", "Details 8"),
                Transaction(9, "Transaction 9", "Income", 180.0, "2023-10-19", "Details 9"),
                Transaction(10, "Transaction 10", "Expense", 60.0, "2023-10-20", "Details 10"),
            ),
            idx = null
        )
    }

    fun printTransactions(): String {
        var string: String = ""
        for (transaction in _uiState.value.transactions) {
            string += transaction.toString() + "\n"
        }
        return string
    }

    fun addTransaction(transaction: Transaction) {
        _uiState.value = _uiState.value.copy(
            transactions = _uiState.value.transactions.toMutableList().apply { add(transaction) }
        )
        println("Added -> $transaction")
    }

    fun deleteTransaction(id: Int) {
        _uiState.value = _uiState.value.copy(
            transactions = _uiState.value.transactions.filter { it.id != id }.toMutableList()
        )
        println("Deleted $id -> ${printTransactions()}")
    }

    fun updateTransaction(transaction: Transaction) {
        _uiState.value = _uiState.value.copy(
            transactions = _uiState.value.transactions.map { if (it.id == transaction.id) transaction else it }.toMutableList()
        )
        println("Updated -> ${printTransactions()}")
    }


}