//
//  Transaction.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import Foundation
import SwiftData

@Model
final class Transaction: Codable, CustomStringConvertible {
    @Attribute(.unique) var id: Int
    var name: String
    var type: String
    var amount: Double
    var date: String
    var details: String

    init(id: Int, name: String, type: String, amount: Double, date: String, details: String) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.date = date
        self.details = details
    }
    
    var description: String {
        return "Transaction(id: \(id), name: \(name), type: \(type), amount: \(amount), date: \(date), details: \(details))"
    }
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case type
        case amount
        case date
        case details
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        amount = try container.decode(Double.self, forKey: .amount)
        date = try container.decode(String.self, forKey: .date)
        details = try container.decode(String.self, forKey: .details)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(details, forKey: .details)
    }
}
