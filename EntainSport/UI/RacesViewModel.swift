//
//  RacesViewModel.swift
//  EntainSport
//
//  Created by Hai Le on 25/10/2023.
//

import Foundation
import SwiftUI
import Combine

private struct RacesViewConstant {
    static let maximumShowItems = 5
}

class RacesViewModel: ObservableObject {
    private let service: Service
    
    @Published var summaries = [RaceSummary]()
    @Published var viewModels = [RaceItemViewModel]()
    
    @Published var selectedGreyhound = true
    @Published var selectedHarness = true
    @Published var selectedHorse = true
    
    // For Select/Deselect all
    @Published var selectedAll = true
    @Published var selectAllImage = Image(systemName: "checkmark.circle.fill")
    @Published var selectAllTitle = "Deselect all"
    
    // Handle error
    @Published var showErrorPopup = false
    @Published var errorMessage = ""
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var currentTime: Date = Date()
    
    init(service: Service) {
        self.service = service
        Task {
            await loadData()
        }
        
        Publishers.CombineLatest4($selectedGreyhound, $selectedHarness, $selectedHorse, $currentTime)
            .sink { [weak self] greyhound, harness, horse, date in
                self?.configureDataWithFilters(greyhound: greyhound,
                                               harness: harness,
                                               horse: horse,
                                               date: date)
                self?.configureButtons(greyhound: greyhound,
                                       harness: harness,
                                       horse: horse)
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
        let firstBatchItems = Array(summaries.prefix(RacesViewConstant.maximumShowItems))
        var selectedSummaries: [RaceSummary]
        if !greyhound, !harness, !horse {
            // Return next 5 items
            selectedSummaries = Array(summaries
                .dropFirst(RacesViewConstant.maximumShowItems)
                .prefix(RacesViewConstant.maximumShowItems))
        } else if greyhound, harness, horse {
            // Return first 5 items
            selectedSummaries = firstBatchItems
        } else {
            // If at least one filter selected, filter the whole list
            selectedSummaries = summaries.filter { item in
                item.category == .greyhound && greyhound ||
                item.category == .harness && harness ||
                item.category == .horse && horse
            }
            selectedSummaries = Array(selectedSummaries.prefix(RacesViewConstant.maximumShowItems))
        }
        
        viewModels = []
        var expiredSummaries = [RaceSummary]()
        for summary in selectedSummaries {
            if let tuple = TimeHelper.formatTimeToValueAndColor(current: date,
                                                                next: Date(timeIntervalSince1970: summary.advertisedStart)) {
                
                viewModels.append(RaceItemViewModel(imageName: summary.category.imageName,
                                                    meetingName: summary.meetingName,
                                                    accessibilityMeetingName: summary.meetingName,
                                                    raceName: summary.raceName,
                                                    accessibilityRaceName: summary.raceName,
                                                    raceNumber: "\(summary.raceNumber)",
                                                    accessibilityRaceNumber: "Race number \(summary.raceNumber)",
                                                    time: tuple.timeDisplayValue,
                                                    accessibilityTime: tuple.timeAccessibilityValue,
                                                    timeColor: tuple.timeColor))
            } else {
                expiredSummaries.append(summary)
            }
        }
        
        // Filter out expired summay
        summaries = summaries.filter { item in
            !expiredSummaries.contains { expiredItem in
                item === expiredItem
            }
        }
  
        // trigger load next batch of events
        if summaries.count < RacesViewConstant.maximumShowItems {
            Task {
                await loadData()
            }
        }
    }
    
    private func configureButtons(greyhound: Bool,
                                  harness: Bool,
                                  horse: Bool) {
        if greyhound, harness, horse {
            selectedAll = true
            selectAllImage = Image(systemName: "checkmark.circle.fill")
            selectAllTitle = "Deselect all"
        } else {
            selectedAll = false
            selectAllImage = Image(systemName: "checkmark.circle")
            selectAllTitle = "Select all"
        }
    }
    
    func loadData() async {
        
        let result = await service.requestRace(size: 20)
        await MainActor.run {
            switch result {
            case .success(let raceResponse):
                var responseSummaries = raceResponse.raceSummaries
                let currentSummaryIDs = summaries.map { $0.raceID }
                responseSummaries = responseSummaries.filter {
                    !currentSummaryIDs.contains($0.raceID)
                }
                
                summaries.append(contentsOf: responseSummaries)
                summaries = summaries.sorted { $0.advertisedStart < $1.advertisedStart }
                
                configureDataWithFilters(greyhound: selectedGreyhound,
                                         harness: selectedHarness,
                                         horse: selectedHorse,
                                         date: currentTime)
            case .failure(let error):
                errorMessage = (error as? NetworkError)?.errorMessage ?? ""
                if !errorMessage.isEmpty {
                    showErrorPopup = true
                }
            }
        }        
    }
    
    func didTapSelectAll() {
        if selectedAll {
            selectedGreyhound = false
            selectedHarness = false
            selectedHorse = false
        } else {
            selectedGreyhound = true
            selectedHarness = true
            selectedHorse = true
        }
    }
}

class TimeHelper {
    static func formatTimeToValueAndColor(current: Date, next: Date) -> (timeDisplayValue: String, timeAccessibilityValue: String, timeColor: Color)? {
        let difference = Calendar.current.dateComponents([.minute, .second],
                                                         from: current,
                                                         to: next)
        
        let minutes = difference.minute ?? 0
        let seconds = difference.second ?? 0
        
        if minutes >= 5 {
            return ("\(minutes)m", "\(minutes) minutes", .neutralLight)
        } else if seconds < 0, seconds >= -59, minutes == 0 {
            return ("\(seconds)s", "Passed \(abs(seconds)) seconds", .error)
        } else if minutes < 0 {
            return nil
        } else if minutes == 0, seconds >= 0 {
            return ("\(seconds)s", "\(seconds) seconds", .secondary2)
        } else {
            return ("\(minutes)m \(seconds)s", "\(minutes) minutes \(seconds) seconds", .secondary2)
        }
    }
}
