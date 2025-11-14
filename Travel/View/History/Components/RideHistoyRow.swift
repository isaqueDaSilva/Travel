//
//  RideHistoyRow.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import SwiftUI

struct RideHistoyRow: View {
    let rideInformation: CustomerRideHistory.Ride
    
    var body: some View {
        GroupBox {
            VStack {
                RideInformationContent(
                    title: "From:",
                    description: "\(rideInformation.origin)"
                )
                
                // TODO: Add a new line for the endpoint of the travel.
                RideInformationContent(
                    title: "To:",
                    description: "\(rideInformation.destination)"
                )
                
                RideInformationContent(
                    title: "Distance:",
                    description: "≈ \(rideInformation.approximateDistance, format: .number) KM"
                )
                
                RideInformationContent(
                    title: "Duration:",
                    description: "\(rideInformation.duration) min."
                )
                
                RideInformationContent(
                    title: "Driver:",
                    description: "\(rideInformation.driver.name)"
                )
                
                RideInformationContent(
                    title: "Value:",
                    description: "\(rideInformation.value, format: .currency(code: "BRL"))"
                )
            }
        } label: {
            VStack(alignment: .leading) {
                Text("\(rideInformation.date, format: .dateTime)")
                
                Rectangle()
                    .frame(height: 1)
            }
        }

    }
}

#Preview {
    RideHistoyRow(
        rideInformation: .init(
            id: 1,
            date: .now,
            origin: "Apple Park",
            destination: "Apple Infinity Loop",
            distance: 4.0,
            duration: "7:00",
            driver: .init(id: 1, name: "Tim Cook"),
            value: 15.0
        )
    )
    .padding()
}
