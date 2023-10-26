//
//  DataHelper.swift
//  EntainSport
//
//  Created by Hai Le on 26/10/2023.
//

import Foundation

class DataHelper {
    static func populateTemporaryDataForPreview(size: Int = 20) async -> Result<RaceResponse, Error> {
        let summaries = (1...size).compactMap { _ in RaceSummary(raceID: randomRaceID, raceName: randomRaceName,
                                                               raceNumber: randomRaceNumber, meetingID: randomMeetingID,
                                                               meetingName: randomMeetingName, category: randomCategory,
                                                               advertisedStart: randomSartTime, distance: randomDistance,
                                                               distanceType: distanceType, raceComment: randomComment,
                                                               venueID: randomVenueID, venueName: randomVenueName,
                                                               venueState: randomVenueState, venueCountry: randomVenueCountry) }
        let response = RaceResponse(raceSummaries: summaries)
        return .success(response)
    }
    
    static private var randomRaceID: String {
        String(Int.random(in: 1..<99999))
    }
    
    static private var randomRaceName: String {
        String("Race \(Int.random(in: 1..<99999))")
    }
    
    static private var randomRaceNumber: Int {
        Int.random(in: 1..<20)
    }
    
    static private var randomMeetingID: String {
        String(Int.random(in: 1..<100))
    }
    
    static private var randomMeetingName: String {
        String("Meeting \(Int.random(in: 1..<100))")
    }
    
    static private var randomCategory: RaceCategory {
        switch Int.random(in: 0..<3) {
        case 0:
            return .greyhound
        case 1:
            return .harness
        default:
            return .horse
        }
    }
    
    static private var randomSartTime: TimeInterval {
        let current = Date()
        let seconds = Int.random(in: 0..<320)
        let next = Calendar.current.date(byAdding: .second, value: seconds, to: current)!
        return next.timeIntervalSince1970
    }
    
    static private var randomDistance: Double {
        Double.random(in: 0..<2000)
    }
    
    static private var distanceType: String {
        "Meters"
    }
    
    static private var randomComment: String {
        "Comment \(Int.random(in: 0..<1000))"
    }
    
    static private var randomVenueID: String {
        "Venue ID \(Int.random(in: 0..<1000))"
    }
    
    static private var randomVenueName: String {
        "Venue name \(Int.random(in: 0..<1000))"
    }
    
    static private var randomVenueState: String {
        "Venue state \(Int.random(in: 0..<1000))"
    }
    
    static private var randomVenueCountry: String {
        "Venue country \(Int.random(in: 0..<1000))"
    }
}
