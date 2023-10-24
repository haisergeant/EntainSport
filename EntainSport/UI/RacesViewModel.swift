//
//  RacesViewModel.swift
//  EntainSport
//
//  Created by Hai Le on 25/10/2023.
//

import Foundation
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
    @Published var currentTime: Date = Date()
    
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
        
        Publishers.CombineLatest4($selectedGreyhound, $selectedHarness, $selectedHorse, $currentTime)
            .sink { [weak self] greyhound, harness, horse, date in
                self?.configureDataWithFilters(greyhound: greyhound,
                                               harness: harness,
                                               horse: horse,
                                               date: date)
            }
            .store(in: &cancellables)
        
        // Setup timer
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .assign(to: \.currentTime, on: self)
            .store(in: &cancellables)

    }
    
    private func configureDataWithFilters(greyhound: Bool,
                                          harness: Bool,
                                          horse: Bool,
                                          date: Date) {
        viewModels = summaries.filter { item in
            item.category == .greyhound && greyhound ||
            item.category == .harness && harness ||
            item.category == .horse && horse
        }
        .compactMap { summary -> RaceItemViewModel? in
            guard let tuple = TimeHelper.formatTimeToValueAndColor(current: date,
                                                                   next: Date(timeIntervalSince1970: summary.advertisedStart)) else { return nil }
            
            return RaceItemViewModel(imageName: summary.category.imageName,
                                     meetingName: summary.meetingName,
                                     raceName: summary.raceName,
                                     raceNumber: "No \n\(summary.raceNumber)",
                                     time: tuple.timeValue,
                                     timeColor: tuple.timeColor)
        }
    }
    
    func loadData() {
        Task {
            let result = await service.requestRace()
            await MainActor.run {
                switch result {
                case .success(let raceResponse):
                    summaries = raceResponse.raceSummaries.sorted { $0.advertisedStart < $1.advertisedStart }
                    configureDataWithFilters(greyhound: selectedGreyhound,
                                             harness: selectedHarness,
                                             horse: selectedHorse,
                                             date: currentTime)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

class TimeHelper {
    static func formatTimeToValueAndColor(current: Date, next: Date) -> (timeValue: String, timeColor: Color)? {
        let difference = Calendar.current.dateComponents([.minute, .second],
                                                         from: current,
                                                         to: next)
        
        let minutes = difference.minute ?? 0
        let seconds = difference.second ?? 0
        
        if minutes >= 5 {
            return ("\(minutes)m", .neutralLight)
        } else if seconds <= 0, seconds >= -59, minutes == 0 {
            return ("\(seconds)s", .error)
        } else if minutes < 0 {
            return nil
        } else if minutes == 0, seconds >= 0 {
            return ("\(seconds)s", .secondary2)
        } else {
            return ("\(minutes)m \(seconds)s", .secondary2)
        }
    }
}
