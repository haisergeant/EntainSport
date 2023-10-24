//
//  EndPoint.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import Foundation

enum EndPoint {
    case race
    
    var url: URL {
        switch self {
        case .race:
            return URL(string: "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10")!
        }
    }
    
    var localUrl: URL {
        switch self {
        case .race:
            fileUrl("racing.json")!
        }
    }
    
    private func fileUrl(_ fileName: String) -> URL? {
        Bundle(identifier: "com.haile.EntainSport")?.url(forResource: fileName, withExtension: nil)
    }
}
