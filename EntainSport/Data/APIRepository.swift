//
//  APIRepository.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case invalidResponse
    case invalidFormat
    case unknown
    
    var errorMessage: String {
        switch self {
        case .noInternet:
            return "No internet connection"
        case .invalidResponse, .invalidFormat:
            return "Invalid response"
        case .unknown:
            return "Something wrong. Please try again"
        }
    }
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

class APIRepository: Repository, Service {
    func requestRace(size: Int = 20) async -> Result<RaceResponse, Error> {
        if isPreview {        
            return await DataHelper.populateTemporaryDataForPreview(size: size)
        }
        
        return await requestData(url: EndPoint.race(size: 20).url)
    }
    
    
}

