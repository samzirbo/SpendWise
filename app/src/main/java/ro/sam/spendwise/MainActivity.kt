package ro.sam.spendwise

import Create
import Update
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import ro.sam.spendwise.ui.screens.Read
import ro.sam.spendwise.ui.theme.SpendwiseTheme

sealed class Screen(val route: String) {
    object Read : Screen("read")
    object Create : Screen("create")
    object Update : Screen("update/{transactionId}") // Use dynamic route for Update screen
}

@Composable
fun App() {
    val navController = rememberNavController()

    NavHost(
        navController = navController,
        startDestination = Screen.Read.route
    ) {
        composable(route = Screen.Read.route) {
            Read(navController)
        }
        composable(route = Screen.Create.route) {
            Create(navController)
        }
        composable(
            route = Screen.Update.route,
            arguments = listOf(navArgument("transactionId") { type = NavType.IntType })
        ) { backStackEntry ->
            val transactionId = backStackEntry.arguments?.getInt("transactionId")
            transactionId?.let { Update(navController, it) }
        }
    }
}


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            SpendwiseTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colorScheme.background
                ) {
                    App()
                }
            }
        }
    }
}

