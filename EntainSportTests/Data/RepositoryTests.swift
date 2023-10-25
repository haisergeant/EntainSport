//
//  RepositoryTests.swift
//  EntainSportTests
//
//  Created by Hai Le on 25/10/2023.
//

import XCTest
@testable import EntainSport

final class RepositoryTests: XCTestCase {
    
    var repository: Repository!
    
    override func setUp() {
        super.setUp()
        repository = Repository(networkMonitor: NetworkMonitor.shared)
    }
    
    func fileUrl(_ fileName: String) -> URL? {
        Bundle(identifier: "com.haile.EntainSportTests")?.url(forResource: fileName, withExtension: nil)
    }

    func testSuccessData() {
        let url = fileUrl("racing-valid-format.json")!
    
        let expectation = self.expectation(description: "Receive valid JSON")
        Task {
            let result: Result<RaceResponse, Error> = await repository.requestData(url: url)
            switch result {
            case .success(let response):
                XCTAssertEqual(response.raceSummaries.count, 10)
                expectation.fulfill()
            case .failure(_):
                XCTFail("API should be success")
            }
        }
        wait(for: [expectation], timeout: 2.0)        
    }
    
    func testFailData() {
        let url = fileUrl("racing-invalid-format.json")!
    
        let expectation = self.expectation(description: "Receive invalid JSON")
        Task {
            let result: Result<RaceResponse, Error> = await repository.requestData(url: url)
            switch result {
            case .success(_):
                XCTFail("API should be fail")
            case .failure(let error):
                XCTAssertEqual((error as? NetworkError), NetworkError.invalidFormat)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
}
