//
//  RequestRideView+ViewModel_Test.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/8/24.
//

import XCTest
@testable import Travel

@MainActor
final class RequestRideView_ViewModel_Test: XCTestCase {
    private typealias ViewModel = RequestRideView.ViewModel
    private var viewModel: ViewModel?
    
    override func setUpWithError() throws {
        viewModel = .init()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_isDisabled_isReturningTrueWhenSomeFieldIsEmpty() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customerID = ""
        viewModel.initialLocation = "1 Apple Park Way, Cupertino, CA, 95014"
        viewModel.destination = "1 Infinite Loop, Cupertino, CA 95014"
        
        XCTAssertTrue(
            viewModel.isDisabled,
            "This test should return true, because the customer id is empty."
        )
    }

    func test_isDisabled_isReturningTrueWhenTheInitialLocationIsSameAsDestination() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customerID = "BOSS"
        viewModel.initialLocation = "1 Apple Park Way, Cupertino, CA, 95014"
        viewModel.destination = "1 Apple Park Way, Cupertino, CA, 95014"
        
        XCTAssertTrue(
            viewModel.isDisabled,
            "This test should return true, because the initial location is the same as the destination."
        )
    }
    
    func test_isDisabled_isReturningTrueWhenWeProcessingTheRequest() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customerID = "BOSS"
        viewModel.initialLocation = "1 Apple Park Way, Cupertino, CA, 95014"
        viewModel.destination = "1 Infinite Loop, Cupertino, CA 95014"
        viewModel.isProcessing = true
        
        XCTAssertTrue(
            viewModel.isDisabled,
            "This test should return true, because we are processing the ride request by user."
        )
    }
    
    func test_isDisabled_isReturningFalseWhenAllPropertiesWasDefinedCorrectly() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customerID = "BOSS"
        viewModel.initialLocation = "1 Apple Park Way, Cupertino, CA, 95014"
        viewModel.destination = "1 Infinite Loop, Cupertino, CA 95014"
        
        XCTAssertFalse(
            viewModel.isDisabled,
            "This test should return false, because the all properties was defined correctly."
        )
    }
    
    func test_makeRideRequest_isWorkingCorrectlyWhenAllPropertiesWasDefinedCorrectly() {
        let expectation = XCTestExpectation(
            description: "Expected the makeRideRequest finishes your work."
        )
        
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customerID = "BOSS"
        viewModel.initialLocation = "1 Apple Park Way, Cupertino, CA, 95014"
        viewModel.destination = "1 Infinite Loop, Cupertino, CA 95014"
        
        let session = URLSession.mockSession
        
        MockURLSession.loadingHandler = {
            let response = HTTPURLResponse(
                url: Endpoint.estimate.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = RideEstimateResponse.mockData
            
            return (response!, data)
        }
        
        viewModel.makeRideRequest(with: session) {
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.ride)
        XCTAssertEqual(viewModel.ride?.origin.latitude, 37.334606)
        XCTAssertEqual(viewModel.ride?.origin.longitude, -122.009102)
        XCTAssertEqual(viewModel.ride?.destination.latitude, 37.33182)
        XCTAssertEqual(viewModel.ride?.destination.longitude, -122.03118)
        XCTAssertEqual(viewModel.ride?.distance, 4)
        XCTAssertEqual(viewModel.ride?.duration, 6)
        XCTAssertEqual(viewModel.ride?.options.count, 1)
        XCTAssertEqual(viewModel.ride?.options[0].id, 1)
        XCTAssertEqual(viewModel.ride?.options[0].name, "Tim Cook")
        XCTAssertEqual(viewModel.ride?.options[0].vehicle, "Tesla Model 3")
        XCTAssertEqual(viewModel.ride?.options[0].value, 10.0)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?.count, 1)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates.count, 3)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates[0].latitude, 38.5)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates[0].longitude, -120.2)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates[1].latitude, 40.7)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates[1].longitude, -120.95)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates[2].latitude, 43.252)
        XCTAssertEqual(viewModel.ride?.routeResponse.routes?[0].coordinates[2].longitude, -126.453)
    }
    
    func test_makeRideRequest_isThrowingAnErrorWhenTheExecutionNotFinishesYourWorkCorrectly() {
        let expectation = XCTestExpectation(
            description: "Expected the makeRideRequest finishes your work."
        )
        
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.customerID = "BOSS1"
        viewModel.initialLocation = "1 Apple Park Way, Cupertino, CA, 95014"
        viewModel.destination = "1 Infinite Loop, Cupertino, CA 95014"
        
        let session = URLSession.mockSession
        
        MockURLSession.loadingHandler = {
            let response = HTTPURLResponse(
                url: Endpoint.estimate.url!,
                statusCode: 400,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = ExecutionError.mockData
            
            return (response!, data)
        }
        
        Task {
            viewModel.makeRideRequest(with: session)
            try? await Task.sleep(for: .seconds(5))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.ride)
        XCTAssertEqual(viewModel.error?.errorCode, "INVALID_ID")
        XCTAssertEqual(viewModel.error?.errorDescription, "Invalid client id")
    }
}
