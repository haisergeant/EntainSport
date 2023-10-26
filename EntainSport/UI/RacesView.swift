//
//  RacesView.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import SwiftUI
import Combine

struct RacesView: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @ObservedObject var viewModel: RacesViewModel
    
    var body: some View {
        if networkMonitor.isConnected {
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        viewModel.didTapSelectAll()
                    }, label: {
                        VStack {
                            viewModel.selectAllImage
                                .renderingMode(.template)
                                .resizable()
                                .padding(4)
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(viewModel.selectedAll ? .secondary2 : .neutralLight)
                            
                            Text(viewModel.selectAllTitle)
                                .foregroundColor(viewModel.selectedAll ? .secondary2 : .neutralLight)
                                .font(.footnote)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                    })
                    
                    
                    Spacer()
                    SelectableButton(viewModel: SelectableButtonViewModel(image: Image(RaceCategory.greyhound.imageName),
                                                                          title: RaceCategory.greyhound.title, selected: $viewModel.selectedGreyhound))
                    SelectableButton(viewModel: SelectableButtonViewModel(image: Image(RaceCategory.harness.imageName),
                                                                          title: RaceCategory.harness.title, selected: $viewModel.selectedHarness))
                    SelectableButton(viewModel: SelectableButtonViewModel(image: Image(RaceCategory.horse.imageName),
                                                                          title: RaceCategory.horse.title, selected: $viewModel.selectedHorse))
                }
                .padding(.horizontal, 20)
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
                    Task {
                        await viewModel.loadData()
                    }
                }
                .listStyle(.plain)
            }
            .background(.secondary1)
        } else {
           Text("No internet connection")
        }
        
    }
}

#Preview {
    RacesView(viewModel: RacesViewModel(service: APIRepository(networkMonitor: NetworkMonitor.shared)))
        .environmentObject(NetworkMonitor.shared)
}
