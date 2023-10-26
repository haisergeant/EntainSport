//
//  Repository.swift
//  EntainSport
//
//  Created by Hai Le on 23/10/2023.
//

import Foundation

// Protocol to define the service to be called
protocol Service {
    func requestRace() async -> Result<RaceResponse, Error>
}

class Repository {
    private let networkMonitor: NetworkMonitor
    
    init(networkMonitor: NetworkMonitor) {
        self.networkMonitor = networkMonitor
    }
    
    func requestData<T: Codable>(url: URL) async -> Result<T, Error> {
        if !url.isFileURL, !networkMonitor.isConnected {
            return .failure(NetworkError.noInternet)
        }
        
        let request = URLRequest(url: url)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return handleResponse(data: data, response: response, isLocalFile: url.isFileURL)
        } catch {
            return .failure(NetworkError.unknown)
        }
    }
    
    private func handleResponse<T: Codable>(data: Data,
                                    response: URLResponse,
                                    isLocalFile: Bool = false) -> Result<T, Error> {
        guard let httpResponse = response as? HTTPURLResponse, !isLocalFile else {
            if isLocalFile {
                return handleData(data: data)
            }
            return .failure(NetworkError.invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return handleData(data: data)
        default:
            return .failure(NetworkError.unknown)
        }
    }
    
    private func handleData<T: Codable>(data: Data) -> Result<T, Error> {
        do {
            let formattedData = try JSONDecoder().decode(T.self, from: data)
            return .success(formattedData)
        } catch {
            print(error)
            return .failure(NetworkError.invalidFormat)
        }
    }
}
