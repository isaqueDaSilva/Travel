//
//  ChoiceARideView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import SwiftUI

struct ChoiceARideView: View {
    let rideEstimated: RideEstimateResponse
    
    @State private var chosenDriver: Int? = nil
    
    var body: some View {
        List(rideEstimated.options, id: \.id) { driver in
            DriverRow(
                wasChosen: $chosenDriver,
                id: driver.id,
                name: driver.name,
                description: driver.description,
                vehicle: driver.vehicle,
                rating: driver.review.rating,
                rideValue: driver.value
            )
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
        }
        .navigationTitle("Motoristas")
    }
}

#Preview {
    NavigationStack {
        ChoiceARideView(
            rideEstimated: .init(
                origin: .init(latitude: 0000, longitude: 0000),
                destination: .init(latitude: 1111, longitude: 111),
                distance: 3,
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
                    )
                ]
            )
        )
    }
}
