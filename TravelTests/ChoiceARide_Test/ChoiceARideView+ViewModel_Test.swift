//
//  ChoiceARideView+ViewModel_Test.swift
//  TravelTests
//
//  Created by Isaque da Silva on 12/9/24.
//

import XCTest
@testable import Travel

@MainActor
final class ChoiceARideView_ViewModel_Test: XCTestCase {
    private typealias ViewModel = ChoiceARideView.ViewModel
    
    private var viewModel: ViewModel?
    
    override func setUpWithError() throws {
        viewModel = .init()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func test_isDisabledButton_isReturningTrueWhenTheChosenDriverIsNil() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        XCTAssertTrue(viewModel.isDisabledButton)
    }
    
    func test_isDisabledButton_isReturningTrueWhenTheRequestingProcessIsRunning() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.isProcessing = true
        
        XCTAssertTrue(viewModel.isDisabledButton)
    }
    
    func test_isDisabledButton_isReturningFalseWhenTheChosenDriverIsNotNil() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.chosenDriver = .init(id: 1, name: "Tim Cook")
        
        XCTAssertFalse(viewModel.isDisabledButton)
    }

    func test_isDisabledDriverRow_isReturningTrueWhenTheChosenDriverIsNotSameAsTheCurrentDriver() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.chosenDriver = .init(id: 1, name: "Tim Cook")
        
        XCTAssertTrue(viewModel.isDisabledDriverRow(driverID: 2))
    }
    
    func test_isDisabledDriverRow_isReturningTrueWhenTheChosenDriverIsTheSameAsTheCurrentDriverAndIsProcessing() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.chosenDriver = .init(id: 1, name: "Tim Cook")
        viewModel.isProcessing = true
        
        XCTAssertTrue(viewModel.isDisabledDriverRow(driverID: 1))
    }
    
    func test_isDisabledDriverRow_isReturningFalseWhenTheChosenDriverIsNilAndIsNotProcessing() {
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        XCTAssertFalse(viewModel.isDisabledDriverRow(driverID: 1))
    }
    
    func test_confirmRide_isReturningTheValueCorrectlyAferYourExecutionFinishes() {
        let expectation = XCTestExpectation(
            description: "Expected the confirmRide finishes your work."
        )
        
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.chosenDriver = .init(id: 1, name: "Tim Cook")
        viewModel.chosenRideValue = 1
        
        let session = URLSession.mockSession
        
        MockURLSession.loadingHandler = {
            let response = HTTPURLResponse(
                url: Endpoint.confirm.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = RideConfirmationResponse.mockData
            
            return (response!, data)
        }
        
        Task {
            viewModel.confirmRide(
                with: session,
                customerID: "CT01",
                origin: "Apple Park",
                destination: "Apple Infinity Loop",
                distance: 4,
                duration: "10 minutes"
            )
            
            try? await Task.sleep(for: .seconds(5))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        XCTAssertTrue(viewModel.isSuccessed)
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertNil(viewModel.error)
    }
    
    func test_confirmRide_isReturningTheErrorCorrectlyWhenTheExecutionFail() {
        let expectation = XCTestExpectation(
            description: "Expected the confirmRide finishes your work."
        )
        
        guard let viewModel else {
            XCTFail("View Model was not defined correctly.")
            return
        }
        
        viewModel.chosenDriver = .init(id: 1, name: "Tim Cook")
        viewModel.chosenRideValue = 1
        
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
            viewModel.confirmRide(
                with: session,
                customerID: "CT01",
                origin: "Apple Park",
                destination: "Apple Infinity Loop",
                distance: 4,
                duration: "10 minutes"
            )
            
            try? await Task.sleep(for: .seconds(5))
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        
        XCTAssertFalse(viewModel.isSuccessed)
        XCTAssertFalse(viewModel.isProcessing)
        XCTAssertNotNil(viewModel.error)
    }
}
