//
//  RacesView.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import SwiftUI
import Combine

class RacesViewModel: ObservableObject {
    private let service: Service
    
    @Published var summaries = [RaceSummary]()
    @Published var viewModels = [RaceItemViewModel]()
    @Published var filterModels = [SelectableButtonViewModel]()
    
    @Published var selectedGreyhound = true
    @Published var selectedHarness = true
    @Published var selectedHorse = true
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(service: Service) {
        self.service = service
        
        loadData()
        filterModels = [
            // Greyhound
            SelectableButtonViewModel(image: Image(RaceCategory.greyhound.imageName),
                                      title: RaceCategory.greyhound.title,
                                      selected:
                                        Binding(get: { self.selectedGreyhound },
                                                        set: { self.selectedGreyhound = $0 })),
            
            SelectableButtonViewModel(image: Image(RaceCategory.harness.imageName),
                                      title: RaceCategory.harness.title,
                                      selected:
                                        Binding(get: { self.selectedHarness },
                                                        set: { self.selectedHarness = $0 })),
            
            SelectableButtonViewModel(image: Image(RaceCategory.horse.imageName),
                                      title: RaceCategory.horse.title,
                                      selected:
                                        Binding(get: { self.selectedHorse },
                                                        set: { self.selectedHorse = $0 }))
        ]
        
        Publishers.CombineLatest3($selectedGreyhound, $selectedHarness, $selectedHorse)
            .sink { [weak self] greyhound, harness, horse in
                self?.configureDataWithFilters(greyhound: greyhound, harness: harness, horse: horse)
            }
            .store(in: &cancellables)
    }
    
    private func configureDataWithFilters(greyhound: Bool, 
                                          harness: Bool,
                                          horse: Bool) {
        viewModels = summaries.filter { item in
            item.category == .greyhound && greyhound ||
            item.category == .harness && harness ||
            item.category == .horse && horse
        }
        .compactMap {
            RaceItemViewModel(imageName: $0.category.imageName,
                              meetingName: $0.meetingName,
                              raceName: $0.raceName,
                              raceNumber: "No \n\($0.raceNumber)",
                              time: $0.advertisedStart)
        }
    }
    
    private func loadData() {
        Task {
            let result = await service.requestRace()
            await MainActor.run {
                switch result {
                case .success(let raceResponse):
                    summaries = raceResponse.raceSummaries.sorted { $0.advertisedStart < $1.advertisedStart }
                    configureDataWithFilters(greyhound: selectedGreyhound,
                                             harness: selectedHarness,
                                             horse: selectedHorse)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

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
            .listStyle(.plain)
        }
        .background(.secondary1)
    }
}

#Preview {
    RacesView(viewModel: RacesViewModel(service: APIRepository()))
}
