//
//  RacesViewModelTests.swift
//  EntainSportTests
//
//  Created by Hai Le on 25/10/2023.
//

import XCTest
@testable import EntainSport

final class RacesViewModelTests: XCTestCase {
    
    private var viewModel: RacesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = RacesViewModel(service: MockRepository(networkMonitor: NetworkMonitor.shared))
    }
    
    func testSelectButton() {
        XCTAssertTrue(viewModel.selectedGreyhound)
        XCTAssertTrue(viewModel.selectedHarness)
        XCTAssertTrue(viewModel.selectedHorse)
        XCTAssertTrue(viewModel.selectedAll)
        XCTAssertEqual(viewModel.selectAllTitle, "Deselect all")
        
        // Deselect one filter
        viewModel.selectedGreyhound = false
        XCTAssertFalse(viewModel.selectedGreyhound)
        XCTAssertTrue(viewModel.selectedHarness)
        XCTAssertTrue(viewModel.selectedHorse)
        XCTAssertFalse(viewModel.selectedAll)
        XCTAssertEqual(viewModel.selectAllTitle, "Select all")
        
        // Tap on select all
        viewModel.didTapSelectAll()
        XCTAssertTrue(viewModel.selectedGreyhound)
        XCTAssertTrue(viewModel.selectedHarness)
        XCTAssertTrue(viewModel.selectedHorse)
        XCTAssertTrue(viewModel.selectedAll)
        XCTAssertEqual(viewModel.selectAllTitle, "Deselect all")
        
        // Tap again on select all
        viewModel.didTapSelectAll()
        XCTAssertFalse(viewModel.selectedGreyhound)
        XCTAssertFalse(viewModel.selectedHarness)
        XCTAssertFalse(viewModel.selectedHorse)
        XCTAssertFalse(viewModel.selectedAll)
        XCTAssertEqual(viewModel.selectAllTitle, "Select all")
    }
    
    func testSummaryData() async {
        
        await viewModel.loadData()
        XCTAssertFalse(viewModel.summaries.isEmpty)
        XCTAssertTrue(viewModel.selectedGreyhound)
        XCTAssertTrue(viewModel.selectedHarness)
        XCTAssertTrue(viewModel.selectedHorse)
        XCTAssertTrue(viewModel.selectedAll)
        XCTAssertEqual(viewModel.selectAllTitle, "Deselect all")
        XCTAssertEqual(viewModel.viewModels.count, 5)
        
    }
}
