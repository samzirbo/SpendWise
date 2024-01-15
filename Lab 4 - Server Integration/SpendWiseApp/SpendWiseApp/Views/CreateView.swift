//
//  CreateView.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import SwiftUI

struct CreateView: View {
    @State var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = "Transaction "
    @State private var type: String = ""
    @State private var amount: Double = 1250.30
    @State private var date: Date = Date()
    @State private var details: String = ""
    
    @State private var validationErrors: [String] = []
    @State private var showToast: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showToast = false
                            }
                        }
                }
                
            }
            .navigationBarTitle("Add Transaction", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    validateForm()
                    if validationErrors.isEmpty {
                        isLoading = true
                        viewModel.addTransaction(id: 0, name: name, type: type, amount: amount, date: date, details: details){
                            isLoading = false
                            dismiss()
                        }
                    } else {
                        showToast = true
                    }
                }
            )
            .overlay(
                Group {
                    if isLoading {
                        Loading(message: "Saving...")
                    }
                }
            )
        }
    }
    
    private func validateForm() {
        validationErrors = []
        
        if type.isEmpty {
            validationErrors.append("Type is required.")
        }
        
        if name.isEmpty {
            validationErrors.append("Name is required.")
        }
        
        if amount <= 0 {
            validationErrors.append("Amount must be greater than 0.")
        }
        
    }
}
