package ro.sam.spendwise.ui.screens

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import ro.sam.spendwise.ui.TransactionViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import ro.sam.spendwise.data.Transaction
import ro.sam.spendwise.data.TransactionCategory
import ro.sam.spendwise.data.TransactionType

@Composable
fun Read(
    navController: NavController,
    transactionViewModel: TransactionViewModel = viewModel(),
) {
    val transactionUIState by transactionViewModel.uiState.collectAsState()
    var isDeleteDialogVisible by remember { mutableStateOf(false) }
    var transactionToDelete: Transaction? by remember { mutableStateOf(null) }

    //create scrollable list of transactions
    LazyColumn {
        items(transactionUIState.transactions) { transaction ->
            TransactionItem(
                transaction,
                onEditClick = {
                    navController.navigate("update/${transaction.id}")
                },
                onDeleteClick = {
                    isDeleteDialogVisible = true
                    transactionToDelete = transaction
                }
            )
        }
    }

    if (isDeleteDialogVisible) {
        AlertDialog(
            onDismissRequest = {
                isDeleteDialogVisible = false
                transactionToDelete = null
            },
            title = { Text("Delete Transaction") },
            text = {
                Text("Are you sure you want to delete this transaction?")
            },
            confirmButton = {
                Button(
                    onClick = {
                        transactionToDelete?.let { transactionViewModel.deleteTransaction(it.id) }
                        isDeleteDialogVisible = false
                        transactionToDelete = null
                    }
                ) {
                    Text("Delete")
                }
            },
            dismissButton = {
                Button(
                    onClick = {
                        isDeleteDialogVisible = false
                        transactionToDelete = null
                    }
                ) {
                    Text("Cancel")
                }
            }
        )
    }

}

@Composable
fun TransactionItem(
    transaction: Transaction,
    onEditClick: () -> Unit = {},
    onDeleteClick: () -> Unit = {},
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        // Display transaction details (title, sum, and date)
        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(text = transaction.name, fontWeight = FontWeight.Bold)
            Text(text = "Amount: $${transaction.amount}")
            Text(text = "Date: ${transaction.date}")
        }

        // Add an Edit button
        IconButton(
            onClick = { onEditClick() }
        ) {
            Icon(imageVector = Icons.Default.Edit, contentDescription = "Edit")
        }

        // Add a Delete button
        IconButton(
            onClick = { onDeleteClick() }
        ) {
            Icon(imageVector = Icons.Default.Delete, contentDescription = "Delete")
        }
    }
}

@Preview(showBackground = true)
@Composable
fun TransactionItemPreview() {
    TransactionItem(
        transaction = Transaction(
            id = 1,
            name = "Salary",
            amount = 1000.0,
            date = "2021-10-10",
            type = "",
            details = "Monthly salary"
        ),
        onDeleteClick = { /*TODO*/ }
    )
}