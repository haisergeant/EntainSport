//
//  RaceResponse.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import Foundation

enum RaceCategory: String, Codable {
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"
    
    var title: String {
        switch self {
        case .greyhound:
            return "Greyhound"
        case .horse:
            return "Horse"
        case .harness:
            return "Harness"
        }
    }
    
    var imageName: String {
        switch self {
        case .greyhound:
            return "greyhound"
        case .horse:
            return "horse"
        case .harness:
            return "harness"
        }
    }
    
}

class RaceSummary: Codable {
    let raceID: String
    let raceName: String
    let raceNumber: Int
    let meetingID: String
    let meetingName: String
    let category: RaceCategory
    let advertisedStart: TimeInterval
    
    let venueID: String
    let venueName: String
    let venueState: String
    let venueCountry: String
    
    enum CodingKeys: String, CodingKey {
        case raceID = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case meetingID = "meeting_id"
        case meetingName = "meeting_name"
        case category = "category_id"
        case advertisedStart = "advertised_start"
        case venueID = "venue_id"
        case venueName = "venue_name"
        case venueState = "venue_state"
        case venueCountry = "venue_country"
    }
    
    enum AdvertisedStartCodingKeys: String, CodingKey {
        case seconds
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.raceID = try container.decode(String.self, forKey: .raceID)
        self.raceName = try container.decode(String.self, forKey: .raceName)
        self.raceNumber = try container.decode(Int.self, forKey: .raceNumber)
        self.meetingID = try container.decode(String.self, forKey: .meetingID)
        self.meetingName = try container.decode(String.self, forKey: .meetingName)
        self.category = try container.decode(RaceCategory.self, forKey: .category)
        
        let advertiseContainer = try container.nestedContainer(keyedBy: AdvertisedStartCodingKeys.self, forKey: .advertisedStart)
        self.advertisedStart = try advertiseContainer.decode(TimeInterval.self, forKey: .seconds)
        
        self.venueID = try container.decode(String.self, forKey: .venueID)
        self.venueName = try container.decode(String.self, forKey: .venueName)
        self.venueState = try container.decode(String.self, forKey: .venueState)
        self.venueCountry = try container.decode(String.self, forKey: .venueCountry)
    }
}

class RaceResponse: Codable {
    
    let raceSummaries: [RaceSummary]
    
    enum Root: String, CodingKey {
        case data
    }
    
    enum DataCodingKeys: String, CodingKey {
        case nextToGoIds = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
    
    required init(from decoder: Decoder) throws {
        let dataContainer = try decoder.container(keyedBy: Root.self)
        let summariesContainer = try dataContainer.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .data)
                
        let values = try summariesContainer.decode([String: RaceSummary].self, forKey: .raceSummaries)
        raceSummaries = Array(values.values)
    }
}
