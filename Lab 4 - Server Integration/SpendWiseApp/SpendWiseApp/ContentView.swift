//
//  ContentView.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.transactions) { transaction in
                HStack {
                    Text(String(transaction.id))
                    Text(transaction.name)
                    Text(String(transaction.amount))
                }
            }
            .navigationTitle("MovieDB")
            .toolbar {
                NavigationLink(destination: ListView(modelContext: viewModel.modelContext)) {
                    Text("List View")
                }
            }
        }
    }

    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}

//#Preview {
//    ContentView()
//        .modelContainer(for: Transaction.self, inMemory: true)
//}
