//
//  NetworkMonitor.swift
//  EntainSport
//
//  Created by Hai Le on 25/10/2023.
//

import Network
import Combine

class NetworkMonitor: ObservableObject {
    static let shared = NetworkMonitor()
    
    private let networkMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "monitor")
        
    #if DEBUG
    var isConnected = true
    #else
    var isConnected = false
    #endif
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied            
            Task {
                await MainActor.run {
                    self.objectWillChange.send
                }
            }
        }
        
        networkMonitor.start(queue: queue)
    }
}
