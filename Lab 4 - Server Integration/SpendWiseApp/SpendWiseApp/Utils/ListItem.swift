//
//  ListItem.swift
//  SpendWise
//
//  Created by George Zirbo on 18.12.2023.
//

import SwiftUI

struct ListItem: View {
    let item: Transaction
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    
    var body: some View {
            HStack {
                Image(systemName: "triangle.fill")
                    .rotationEffect(item.type == "Expense" ? Angle(degrees: 180) : .zero)
                    .foregroundColor(item.type == "Income" ? .green.opacity(0.7) : .red.opacity(0.7))
                    .font(.system(size: 15))

                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    if let date = dateFormatter.date(from: item.date) {
                        Text(date, style: .date)
                            .font(.subheadline)
                    } else {
                        Text("Invalid Date Format")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                }
                .padding(.leading, 5)

                Spacer()

                Text("\(item.amount, specifier: "$%.2f")")
                    .foregroundColor(item.type == "Income" ? .green.opacity(0.7) : .red.opacity(0.7))
                    .font(.headline)
                    .environment(\.locale, Locale(identifier: "en_US"))
            }
        }
}


//
//#Preview {
//    Group {
//        ListItem(item: Transaction.exampleIncome)
//        ListItem(item: Transaction.exampleExpense)
//    }
//}
