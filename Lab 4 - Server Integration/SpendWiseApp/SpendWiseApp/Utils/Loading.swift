//
//  Loading.swift
//  SpendWise
//
//  Created by George Zirbo on 13.01.2024.
//

import SwiftUI

struct Loading: View {
    let message: String
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
            ProgressView(message)
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    Loading(message: "Saving...")
}
