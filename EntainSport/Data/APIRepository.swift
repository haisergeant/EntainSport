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
}

enum Result<T, Error> {
    case success(T)
    case failure(Error)
}

class APIRepository: Repository, Service {
    func requestRace() async -> Result<RaceResponse, Error> {
        if isPreview {        
            return await DataHelper.populateTemporaryDataForPreview()
        }
        
        return await requestData(url: EndPoint.race.url)
    }
    
    
}

