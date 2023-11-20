import android.widget.RadioGroup
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
import androidx.compose.material3.RadioButtonDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import ro.sam.spendwise.ui.TransactionViewModel
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import ro.sam.spendwise.Screen
import ro.sam.spendwise.data.Transaction
import ro.sam.spendwise.ui.screens.Read


@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun Update(
    navController: NavController,
    transactionID: Int,
    transactionViewModel: TransactionViewModel = viewModel(),
) {
    val transactionUIState by transactionViewModel.uiState.collectAsState()

    val transaction: Transaction = transactionUIState.transactions.find { it.id == transactionID } !!
    var name by remember { mutableStateOf(transaction.name) }
    var type by remember { mutableStateOf(transaction.type) }
    var amount by remember { mutableStateOf(transaction.amount) }
    var date by remember { mutableStateOf(transaction.date) }
    var details by remember { mutableStateOf(transaction.details) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
            .verticalScroll(rememberScrollState())
    ) {

        Row (
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceEvenly
        ){
            Row() {
                RadioButton(
                    selected = type == "Expense",
                    onClick = { type = "Expense" },
                    modifier = Modifier.align(Alignment.CenterVertically),
                    colors = RadioButtonDefaults.colors(
                        selectedColor = Color(0xFFFFBB5C)
                    )
                )
                Text("Expense",  modifier = Modifier
                    .padding(8.dp)
                    .align(Alignment.CenterVertically))
            }
            Row() {
                RadioButton(
                    selected = type == "Income",
                    onClick = { type = "Income"},
                    modifier = Modifier.align(Alignment.CenterVertically),
                    colors = RadioButtonDefaults.colors(
                        selectedColor = Color(0xFFFFBB5C)
                    )
                )
                Text("Income", modifier = Modifier
                    .padding(8.dp)
                    .align(Alignment.CenterVertically))
            }
        }

        OutlinedTextField(
            value = name,
            onValueChange = { name = it },
            label = { Text("Name") },
            modifier = Modifier.fillMaxWidth() // Fill the entire width
        )

        OutlinedTextField(
            value = amount.toString(),
            onValueChange = { amount = it.toDoubleOrNull() ?: 0.0 },
            label = { Text("Amount") },
            modifier = Modifier.fillMaxWidth() // Fill the entire width
        )

        OutlinedTextField(
            value = date,
            onValueChange = { date = it },
            placeholder = { Text("yyyy-mm-dd") },
            label = { Text("Date") },
            modifier = Modifier.fillMaxWidth()
        )

        OutlinedTextField(
            value = details?:"",
            onValueChange = { details = it },
            label = { Text("Details") },
            modifier = Modifier.fillMaxWidth()
        )

        Button(
            onClick = {
                val newTransaction = Transaction(
                    id = transactionID,
                    name = name,
                    type = type,
                    amount = amount,
                    date = date,
                    details = details
                )
                transactionViewModel.updateTransaction(newTransaction)
                navController.navigate(Screen.Read.route)
            },
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = 16.dp)
                .background(Color.Transparent),
            enabled = validateInputs(name, amount, date),
            colors = ButtonDefaults.buttonColors(
                containerColor = Color(0xFFFFBB5C),
                contentColor = Color.White)
        ) {
            Text("Update")
        }
    }
}

@Preview(showBackground = true)
@Composable
fun TransactionsPreview() {
    Update(navController = NavController(LocalContext.current), transactionID = 1)
}
