//
//  NetworkManager.swift
//  SpendWiseApp
//
//  Created by George Zirbo on 15.01.2024.
//

import SwiftUI
import Network


protocol NetworkStatusDelegate: AnyObject {
    func backOnline()
}

class NetworkMonitor: ObservableObject {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue (label: "Monitor")
    @Published var isConnected = false
    weak var delegate: NetworkStatusDelegate?
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }

            DispatchQueue.main.async {
                print("Path status: \(path.status)")
                let wasConnected = self.isConnected
                self.isConnected = path.status == .satisfied

                if !wasConnected && self.isConnected {
//                    print("Network: Back online!")
                    self.delegate?.backOnline()
                }
            }
        }
        monitor.start(queue: queue)
    }
}
