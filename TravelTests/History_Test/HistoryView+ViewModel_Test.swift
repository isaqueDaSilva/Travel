//
//  HistoryView+ViewModel_Test.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/11/24.
//

import XCTest
@testable import Travel

@MainActor
final class HistoryView_ViewModel_Test: XCTestCase {
    private var viewModel: HistoryView.ViewModel?
    
    override func setUpWithError() throws {
        viewModel = .init()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_isDisabled_isReturningTrueWhenTheCustomerIDIsEmpty() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customID = ""
        
        XCTAssertTrue(viewModel.isDisabled)
    }
    
    func test_isDisabled_isReturningFalseWhenTheCustomerIDIsNotEmpty() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customID = "01"
        
        XCTAssertFalse(viewModel.isDisabled)
    }
    
    func test_getHistory_isReturningTheCustomerRideHistoryAfterYourExecution() {
        let expectation = XCTestExpectation(
            description: "Expected the getHistory finishes your work correctly."
        )
        
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customID = "01"
        
        let session = URLSession.mockSession
        
        MockURLSession.loadingHandler = {
            let response = HTTPURLResponse(
                url: Endpoint.confirm.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = CustomerRideHistory.mockData
            
            return (response!, data)
        }
        
        Task {
            viewModel.getHistory(with: session)
            
            try? await Task.sleep(for: .seconds(5))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.rideHistory)
        XCTAssertEqual(viewModel.rideHistory?.customerID, "01")
        XCTAssertEqual(viewModel.rideHistory?.rides.count, 1)
        XCTAssertEqual(viewModel.rideHistory?.rides[0].id, 1)
        XCTAssertEqual(viewModel.rideHistory?.rides[0].origin, "Apple Park")
        XCTAssertEqual(viewModel.rideHistory?.rides[0].destination, "Apple Infinity Loop")
        XCTAssertEqual(viewModel.rideHistory?.rides[0].distance, 7.0)
        XCTAssertEqual(viewModel.rideHistory?.rides[0].duration, "7:34")
        XCTAssertEqual(viewModel.rideHistory?.rides[0].driver.id, 1)
        XCTAssertEqual(viewModel.rideHistory?.rides[0].driver.name, "Tim Cook")
        XCTAssertEqual(viewModel.rideHistory?.rides[0].value, 15.00)
        
        let dateString = "2024-08-18T16:04:00"
        
        XCTAssertEqual(viewModel.rideHistory?.rides[0].date, dateString.date)
    }

    func test_getHistory_isReturningAnExecutionErrorAfterYourExecution() {
        let expectation = XCTestExpectation(
            description: "Expected the getHistory finishes your work correctly."
        )
        
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customID = "01"
        
        let session = URLSession.mockSession
        
        MockURLSession.loadingHandler = {
            let response = HTTPURLResponse(
                url: Endpoint.confirm.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = ExecutionError.mockData
            
            return (response!, data)
        }
        
        Task {
            viewModel.getHistory(with: session)
            
            try? await Task.sleep(for: .seconds(5))
            
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertNil(viewModel.rideHistory)
        XCTAssertNotNil(viewModel.error)
        XCTAssertEqual(viewModel.error?.errorCode, "INVALID_ID")
        XCTAssertEqual(viewModel.error?.errorDescription, "Invalid client id")
    }
}
