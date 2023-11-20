package ro.sam.spendwise.ui

import ro.sam.spendwise.data.Transaction

data class TransactionUIState (
    val transactions: MutableList<Transaction> = mutableListOf()
)