//
//  UpdateView.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import SwiftUI
import SwiftData

struct UpdateView: View {
    @State var viewModel: ViewModel
    @Bindable private var transaction: Transaction
    
    @State private var id: Int
    @State private var name: String
    @State private var type: String
    @State private var amount: Double
    @State private var date: Date
    @State private var details: String
    
    @Environment(\.dismiss) var dismiss
    
    @State private var validationErrors: [String] = []
    @State private var showToast: Bool = false
    @State private var isLoading: Bool = false
    @State private var notConnected: Bool = false
    
    init(viewModel: ViewModel, transaction: Transaction) {
        _viewModel = State(initialValue: viewModel)
        _transaction = Bindable(transaction)
        _id = State(initialValue: transaction.id)
        _name = State(initialValue: transaction.name)
        _type = State(initialValue: transaction.type)
        _amount = State(initialValue: transaction.amount)
        _date = State(initialValue: viewModel.dateFormatter.date(from: transaction.date)!)
        _details = State(initialValue: transaction.details)
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Form {
                    Section(header: Text("Transaction Type")) {
                        Picker("Type", selection: $type) {
                            ForEach(["Expense", "Income"], id: \.self) { transactionType in
                                Text(transactionType)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Section(header: Text("Transaction Details")) {
                        TextField("Name", text: $name)
                            .disableAutocorrection(true)
                        TextField("Amount", value: $amount, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                        DatePicker("Date", selection: $date, in: ...Date(), displayedComponents: .date)
                        TextField("Details", text: $details)
                    }
                }
                Spacer()

                if showToast {
                    Toast(message: validationErrors.first ?? "", backgroundColor: .red)
                        .padding(.bottom, 16)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showToast = false
                            }
                        }
                }
            }
            .alert(isPresented: $notConnected) {
                Alert(
                    title: Text("Lost connection"),
                    message: Text("This operation cannot be performed while offline."),
                    dismissButton: .default(Text("Ok")) {
                            notConnected = false
                    }
                )
            }
            .overlay(
                Group {
                    if isLoading {
                        Loading(message: "Updating...")
                    }
                }
            )
            
            
        }
        .navigationBarTitle("Update Transaction", displayMode: .inline)
        .navigationBarItems(
            trailing: Button("Save") {
                validateForm()
                if validationErrors.isEmpty {
                    if viewModel.network.isConnected {
                        isLoading = true
                        viewModel.updateTransaction(id: id, name: name, type: type, amount: amount, date: date, details: details){
                            isLoading = false
                            dismiss()
                        }
                        
                    } else {
                        notConnected = true
                    }
                } else {
                    print("Validation errors")
                    showToast = true
                }
            }
        )
    }
    
    private func validateForm() {
        validationErrors = []
        
        if name.isEmpty {
            validationErrors.append("Name is required.")
        }
        if type.isEmpty {
            validationErrors.append("Type is required.")
        }
        if amount <= 0 {
            validationErrors.append("Amount must be greater than 0.")
        }
        
    }
}
