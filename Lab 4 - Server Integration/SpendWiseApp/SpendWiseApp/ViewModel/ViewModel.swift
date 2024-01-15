//
//  ViewModel.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import Foundation
import SwiftData
import SwiftUI

struct Response: Codable {
    let message: String
    let data: [Transaction]
}


@Observable
class ViewModel: ObservableObject, NetworkStatusDelegate {
    
    
    var modelContext: ModelContext
    var network: NetworkMonitor
    var transactions =  [Transaction]()
    private var baseURL: String = "http://192.168.1.5:8000/transaction"
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    init(modelContext: ModelContext) {
        _modelContext = modelContext
        _network = NetworkMonitor()
        _network.delegate = self
        refresh()
    }
    
    
    
    func getTransaction(id: Int) -> Transaction? {
        do {
              let predicate = #Predicate<Transaction> { object in
                  object.id == id
              }
              var descriptor = FetchDescriptor(predicate: predicate)
              descriptor.fetchLimit = 1
              let object = try modelContext.fetch(descriptor)
              return object.first
            
            } catch {
              print("Error: getTransaction(\(id)")
              return nil
          }
    }
    
    func refresh() {
        do {
            let descriptor = FetchDescriptor<Transaction>(sortBy: [SortDescriptor(\.date)])
            transactions = try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed")
        }
    }
    
    func updateTransaction(id: Int, name: String, type: String, amount: Double, date: Date, details: String, completion: @escaping () -> Void){
        guard let url = URL(string: baseURL + "/\(id)?name=\(name)&type=\(type)&amount=\(amount)&date=\(self.dateFormatter.string(from: date))&details=\(details)") else {
            print("Invalid URL")
            return
        }

        Task.detached {
            do {
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                
                let (_, _response) = try await URLSession.shared.data(for: request)

                guard let _response = _response as? HTTPURLResponse, _response.statusCode == 202 else {
                    let errorMessage = "Error: updateTransaction(\(id)) could not be performed"
                    throw NSError(domain: "deleteTransaction", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                print("Server: updateTransaction(\(id))")
                
                let transaction = self.getTransaction(id: id)!
                transaction.name = name
                transaction.type = type
                transaction.amount = amount
                transaction.date = self.dateFormatter.string(from: date)
                transaction.details = details
                print("DB: updateTransaction(\(transaction))")
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
        
    }
    
    func addTransaction(id: Int, name: String, type: String, amount: Double, date: Date, details: String, completion: @escaping () -> Void) {
        var newId = id
        if newId == 0{
            newId = getId()
        }
        let transaction = Transaction(id: newId, name: name, type: type, amount: amount, date: dateFormatter.string(from: date), details: details)
        modelContext.insert(transaction)
        print("DB: addedTransaction -> \(transaction)")
        refresh()
        
        guard let url = URL(string: baseURL) else {
            print("Invalid URL")
            return
        }

        Task.detached {
            do {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                let encoded = try JSONEncoder().encode(transaction)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = encoded

                let (_, _response) = try await URLSession.shared.data(for: request)

                guard let _response = _response as? HTTPURLResponse, _response.statusCode == 201 else {
                    let errorMessage = "Error: addTransaction(\(transaction.id)) could not be performed"
                    throw NSError(domain: "deleteTransaction", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                print("Server: addTransaction -> \(transaction)")
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deleteTransaction(id: Int, completion: @escaping () -> Void) {
        guard let url = URL(string: baseURL + "/\(id)") else {
            print("Invalid URL")
            return
        }

        Task.detached {
            do {
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                
                let (_, _response) = try await URLSession.shared.data(for: request)

                guard let _response = _response as? HTTPURLResponse, _response.statusCode == 202 else {
                    let errorMessage = "Error: deleteTransaction(\(id)) could not be performed"
                    throw NSError(domain: "deleteTransaction", code: 1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                }
                print("Server: deleteTransaction(\(id))")
                
                let transaction = self.getTransaction(id: id)!
                let descr = transaction.description
                self.modelContext.delete(transaction)
                print("DB: deletedTransaction(\(descr))")
                self.refresh()
                
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func getId() -> Int {
        let nextId: Int
        if let maxId = transactions.max(by: { $0.id < $1.id })?.id {
            nextId = maxId + 1
        } else {
            nextId = 1
        }
        return nextId
    }
    
    func backOnline() {
//        print("Network: Back online!")
    }
}
