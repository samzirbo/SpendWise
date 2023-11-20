package ro.sam.spendwise.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.FloatingActionButtonDefaults
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
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import ro.sam.spendwise.ui.TransactionViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import ro.sam.spendwise.Screen
import ro.sam.spendwise.data.Transaction

@Composable
fun Read(
    navController: NavController,
    transactionViewModel: TransactionViewModel = viewModel(),
) {
    val transactionUIState by transactionViewModel.uiState.collectAsState()
    var isDeleteDialogVisible by remember { mutableStateOf(false) }
    var transactionToDelete: Transaction? by remember { mutableStateOf(null) }

    LazyColumn {
        items(transactionUIState.transactions) { transaction ->
            TransactionItem(
                transaction,
                onClick = {
                    navController.navigate("update/${transaction.id}")
                },
                onEditClick = {
                    navController.navigate("update/${transaction.id}")
                },
                onDeleteClick = {
                    isDeleteDialogVisible = true
                    transactionToDelete = transaction
                },
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
    Box(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
            .padding(bottom = 16.dp, end = 16.dp),
        contentAlignment = Alignment.BottomEnd,
    ) {
        FloatingActionButton(
            onClick = {
                navController.navigate(Screen.Create.route)
            },
            shape = CircleShape,
            contentColor = Color.White,
            elevation = FloatingActionButtonDefaults.elevation(defaultElevation = 6.dp),
            containerColor = Color(0xFFC6D57E),
        ) {
            Text("+")
        }
    }


}

@Composable
fun TransactionItem(
    transaction: Transaction,
    onClick: () -> Unit = {},
    onEditClick: () -> Unit = {},
    onDeleteClick: () -> Unit = {},
) {
    val rowBackgroundColor = Color(0xA0E0E0E0) // Light Gray
    val editButtonColor = Color(0xFF96B6C5) // Pastel Blue
    val deleteButtonColor = Color(0xFFD57E7E) // Pastel Red
    val textColor = Color(0xFF333333) // Dark Gray

    Row(
        modifier = Modifier
            .fillMaxWidth()
            .clickable { onClick() }
            .background(rowBackgroundColor) // Set the background color for the row
            .border(
                1.dp,
                Color.LightGray,
                shape = RoundedCornerShape(6.dp)
            ) // Add light gray borders with rounded corners
            .padding(16.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Column(
            modifier = Modifier.weight(1f)
        ) {
            Text(
                text = transaction.name,
                fontWeight = FontWeight.Bold,
                color = textColor // Set text color to dark gray
            )
            Text(
                text = "Amount: $${transaction.amount}",
                color = textColor // Set text color to dark gray
            )
            Text(
                text = "Date: ${transaction.date}",
                color = textColor // Set text color to dark gray
            )
        }

        // Add an Edit button
        IconButton(
            onClick = { onEditClick() },
            modifier = Modifier
                .background(Color.Transparent) // Set the background to transparent
        ) {
            Icon(
                imageVector = Icons.Default.Edit,
                contentDescription = "Edit",
                tint = editButtonColor // Set the icon color to pastel blue
            )
        }

        // Add a Delete button
        IconButton(
            onClick = { onDeleteClick() },
            modifier = Modifier
                .background(Color.Transparent) // Set the background to transparent
        ) {
            Icon(
                imageVector = Icons.Default.Delete,
                contentDescription = "Delete",
                tint = deleteButtonColor
            )
        }
    }
}



@Preview(showBackground = true)
@Composable
fun TransactionsPreview() {
    Read(navController = NavController(LocalContext.current))
}