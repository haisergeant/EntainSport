//
//  EntainSportApp.swift
//  EntainSport
//
//  Created by Hai Le on 22/10/2023.
//

import SwiftUI

@main
struct EntainSportApp: App {
    var body: some Scene {
        WindowGroup {
            RacesView(viewModel: RacesViewModel(service: APIRepository()))
        }
    }
}
