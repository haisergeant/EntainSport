//
//  RacesView.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import SwiftUI
import Combine

struct RacesView: View {
    @ObservedObject var viewModel: RacesViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(viewModel.filterModels, id: \.title) { item in
                    SelectableButton(viewModel: item)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 10)
            
            List {
                ForEach(0..<viewModel.viewModels.count, id: \.self) { item in
                    RaceItemView(viewModel: viewModel.viewModels[item])
                        .background(item % 2 == 0 ? .main : .secondary1)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                }
            }
            .refreshable {
                viewModel.loadData()
            }
            .listStyle(.plain)
        }
        .background(.secondary1)
    }
}

#Preview {
    RacesView(viewModel: RacesViewModel(service: APIRepository()))
}
