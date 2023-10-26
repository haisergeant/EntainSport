//
//  MockRepository.swift
//  EntainSportTests
//
//  Created by Hai Le on 26/10/2023.
//

import Foundation
@testable import EntainSport

class MockRepository: Repository, Service {
    
    func requestRace() async -> Result<RaceResponse, Error> {
        return await DataHelper.populateTemporaryDataForPreview()
    }
}
