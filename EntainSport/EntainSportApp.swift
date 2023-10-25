//
//  EntainSportApp.swift
//  EntainSport
//
//  Created by Hai Le on 22/10/2023.
//

import SwiftUI

@main
struct EntainSportApp: App {
    @StateObject var networkMonitor = NetworkMonitor.shared
    
    var body: some Scene {
        WindowGroup {
            RacesView(viewModel: RacesViewModel(service: APIRepository(networkMonitor: networkMonitor)))
                .environmentObject(networkMonitor)
        }
    }
}
