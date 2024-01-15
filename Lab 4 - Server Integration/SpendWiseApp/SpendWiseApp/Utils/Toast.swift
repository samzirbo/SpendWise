//
//  Toast.swift
//  SpendWise
//
//  Created by George Zirbo on 18.12.2023.
//

import SwiftUI

struct Toast: View {
    let message: String
    let backgroundColor: Color
    
    var body: some View {
        Text(message)
            .padding()
            .background(backgroundColor.opacity(0.65))
            .foregroundColor(.white)
            .cornerRadius(25)
            .offset(y: UIScreen.main.bounds.height / 2 -  100)
            .animation(.easeInOut, value: true)
   }
}

#Preview {
    Toast(message: "Transaction Added", backgroundColor: .green)
}
