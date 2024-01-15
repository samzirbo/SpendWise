//
//  ListView.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import SwiftUI
import SwiftData

struct ListView: View {
    
    @State var viewModel: ViewModel
    @State private var showCreateView = false
    @State private var selectedTransaction: Transaction?
    @State private var showAlert = false
    @State private var isLoading = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.transactions) { transaction in
                    NavigationLink(destination:
                        UpdateView(viewModel: viewModel, transaction: transaction)
                            .environmentObject(viewModel)
                    ){
                        ListItem(item: transaction)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            selectedTransaction = transaction
                            if !viewModel.network.isConnected {
                                alertMessage = "not connected"
                            } else {
                                alertMessage = "confirm"
                            }
                            showAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                if alertMessage == "confirm"{
                    Alert(
                        title: Text("Confirm Deletion"),
                        message: Text("Are you sure you want to delete this transaction?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let selectedTransaction = selectedTransaction {
                                isLoading = true
                                viewModel.deleteTransaction(id: selectedTransaction.id) {
                                    isLoading = false
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                } else {
                    Alert(
                        title: Text("Lost connection"),
                        message: Text("This operation cannot be performed while offline. "),
                        dismissButton: .default(Text("Ok"))
                    )
                }
            }
            
            .sheet(isPresented: $showCreateView) {
                CreateView(viewModel: viewModel)
            }
            .navigationTitle("Transactions")
            .navigationBarItems(trailing: Button(action: {
                showCreateView.toggle()
            }) {
                Image(systemName: "plus")
            })
            .overlay(
                Group {
                    if isLoading {
                        Loading(message: "Deleting...")
                    }
                }
            )
        }
    }
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
