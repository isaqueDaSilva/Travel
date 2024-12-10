//
//  ChoiceARideView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import SwiftUI

struct ChoiceARideView: View {
    @Binding var path: [RideEstimateResponse]
    
    let rideEstimated: RideEstimateResponse
    let customerID: String
    let origin: String
    let destination: String
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                Group {
                    if rideEstimated.options.isEmpty {
                        emptyDriverIndicator
                            .containerRelativeFrame(.vertical, alignment: .center)
                    } else {
                        driverList
                        
                        ActionButton(
                            isProcessing: $viewModel.isProcessing,
                            title: "Confirmar viagem",
                            isDisabled: viewModel.isDisabledButton
                        ) {
                            viewModel.confirmRide(
                                customerID: customerID,
                                origin: origin,
                                destination: destination,
                                distance: rideEstimated.distance,
                                duration: "\(rideEstimated.duration)"
                            )
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Motoristas")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    path.removeAll()
                } label: {
                    Image(systemName: "chevron.left")
                    Text("Voltar")
                }
                .disabled(path.isEmpty)
            }
        }
        .errorAlert(error: $viewModel.error) { }
    }
    
    init(
        path: Binding<[RideEstimateResponse]>,
        rideEstimated: RideEstimateResponse,
        customerID: String,
        origin: String,
        destination: String
    ) {
        self._path = path
        self.rideEstimated = rideEstimated
        self.customerID = customerID
        self.origin = origin
        self.destination = destination
    }
}

extension ChoiceARideView {
    @ViewBuilder
    private var driverList: some View {
        ForEach(rideEstimated.options, id: \.id) { driver in
            DriverRow(
                wasChosen: $viewModel.chosenDriver,
                chosenRideValue: $viewModel.chosenRideValue,
                id: driver.id,
                name: driver.name,
                description: driver.description,
                vehicle: driver.vehicle,
                rating: driver.review.rating,
                rideValue: driver.value
            )
            .disabled(
                viewModel.isDisabledDriverRow(
                    driverID: driver.id
                ) ||
                !viewModel.isValidDistance(for: driver.id, distance: rideEstimated.distanceInKM)
            )
            .opacity(
                viewModel.isDisabledDriverRow(
                    driverID: driver.id
                ) ||
                !viewModel.isValidDistance(for: driver.id, distance: rideEstimated.distanceInKM)
                ? 0.5 : 1
            )
            
        }
    }
    
    @ViewBuilder
    private var emptyDriverIndicator: some View {
        ContentUnavailableView(
            "Nenhum motorista disponível",
            systemImage: "car.side.roof.cargo.carrier.slash",
            description: Text("Ops! Parece que não há motoristas disponíveis para reslizar sua viagem no momento.")
        )
    }
}

#Preview("With Drivers Options") {
    NavigationStack {
        ChoiceARideView(
            path: .constant([]),
            rideEstimated: .init(
                origin: .init(latitude: 0000, longitude: 0000),
                destination: .init(latitude: 1111, longitude: 111),
                distance: 1000,
                duration: 2,
                options: [
                    .init(
                        id: 1,
                        name: "Tim Cook",
                        description: "Some",
                        vehicle: "Tesla Model 3",
                        review: .init(
                            rating: 4,
                            comment: "Some"
                        ),
                        value: 10.0
                    ),
                    .init(
                        id: 2,
                        name: "John Ternus",
                        description: "Some 2",
                        vehicle: "Tesla Model 3",
                        review: .init(
                            rating: 5,
                            comment: "Some"
                        ),
                        value: 10.0
                    )
                ]
            ),
            customerID: "CT01",
            origin: "Apple Park",
            destination: "Apple Infinite Loop"
        )
    }
}

#Preview("Empty Driver Options") {
    NavigationStack {
        ChoiceARideView(
            path: .constant([]),
            rideEstimated: .init(
                origin: .init(latitude: 0000, longitude: 0000),
                destination: .init(latitude: 1111, longitude: 111),
                distance: 3,
                duration: 2,
                options: []
            ),
            customerID: "CT01",
            origin: "Apple Park",
            destination: "Apple Infinite Loop"
        )
    }
}
