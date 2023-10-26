//
//  EndPoint.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import Foundation

// EndPoint
enum EndPoint {
    case race(size: Int)
    
    /// API Endpoint
    var url: URL {
        switch self {
        case .race(let size):
            return URL(string: "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=\(size)")!
        }
    }
    
    /// Map to local file, used in Preview in SwiftUI
    var localUrl: URL {
        switch self {
        case .race:
            return fileUrl("racing.json")!
        }
    }
    
    private func fileUrl(_ fileName: String) -> URL? {
        Bundle(identifier: "com.haile.EntainSport")?.url(forResource: fileName, withExtension: nil)
    }
}
