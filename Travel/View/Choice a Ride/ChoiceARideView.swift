//
//  ChoiceARideView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import MapKit
import SwiftUI

// TODO: Transform this view in a path confirmation view
// The user will see your required travel path and confirm if it's correct
struct ChoiceARideView: View {
    @Binding var path: [Int]
    
    let rideEstimated: RideEstimateResponse
    let customerID: String
    let origin: String
    let destination: String
    
    @State private var viewModel = ViewModel()
    
    @State private var currentOffeset: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                let startOffset = proxy.size.height * 0.65
                
                Map {
                    ForEach(rideEstimated.routeResponse.routes ?? [], id: \.id) { route in
                        
                        if !route.coordinates.isEmpty {
                            MapPolyline(coordinates: route.coordinates)
                                .stroke((route.coordinates.first != nil) ? .blue : .blue.opacity(0.5), lineWidth: 10)
                            
                            if let initialLocation = route.coordinates.first {
                                Marker(coordinate: initialLocation) {
                                    Image(systemName: "star.fill")
                                }
                            }
                            
                            if let destination = route.coordinates.last {
                                Marker(coordinate: destination) {
                                    Image(systemName: "mappin")
                                }
                            }
                        }
                    }
                }
                
                // TODO: Change for a confirm path buttom
                choiceADriver
                    .background {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.white)
                    }
                    .ignoresSafeArea(edges: .bottom)
                    .offset(y: startOffset)
                    .offset(y: currentOffeset)
                    .offset(y: endingOffsetY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                withAnimation {
                                    currentOffeset = value.translation.height
                                }
                            }
                            .onEnded { _ in
                                withAnimation {
                                    if currentOffeset < -120 {
                                        endingOffsetY = -startOffset
                                    } else if endingOffsetY != 0 && currentOffeset > 120 {
                                        endingOffsetY = 0
                                    }
                                    
                                    currentOffeset = 0
                                }
                            }
                    )
            }
        }
        .navigationBarBackButtonHidden()
        .toolbarBackground(.hidden, for: .navigationBar)
        .errorAlert(error: $viewModel.error)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(isDisabled: path.isEmpty) {
                    path.removeAll()
                }
            }
        }
    }
    
    init(
        path: Binding<[Int]>,
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
    
    @ViewBuilder
    private var choiceADriver: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.secondary)
                .frame(width: 50, height: 5)
            
            HStack {
                Text("Motoristas")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ActionButton(
                    isProcessing: $viewModel.isProcessing,
                    title: "Confirmar",
                    isDisabled: viewModel.isDisabledButton
                ) {
                    viewModel.confirmRide(
                        customerID: customerID,
                        origin: origin,
                        destination: destination,
                        distance: rideEstimated.distance,
                        duration: "\(rideEstimated.duration)"
                    ) {
                        path.append(2)
                    }
                }
            }
            
            ScrollView {
                VStack {
                    Group {
                        if rideEstimated.options.isEmpty {
                            emptyDriverIndicator

                        } else {
                            driverList
                        }
                    }
                }
            }
        }
        .padding()
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
                ],
                routeResponse: .init(routes: [
                    .init(legs: [
                        .init(
                            polyline: .init(
                                encodedPolyline: "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
                            )
                        )
                    ])
                ])
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
                options: [],
                routeResponse: .init(routes: [])
            ),
            customerID: "CT01",
            origin: "Apple Park",
            destination: "Apple Infinite Loop"
        )
    }
}
