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
                    title: "Origem",
                    description: "\(rideInformation.origin)"
                )
                
                RideInformationContent(
                    title: "Data da Viagem",
                    description: "\(rideInformation.date, format: .dateTime)"
                )
                
                RideInformationContent(
                    title: "Distância",
                    description: "≈ \(rideInformation.approximateDistance, format: .number) KM"
                )
                
                RideInformationContent(
                    title: "Duração",
                    description: "\(rideInformation.duration) min."
                )
                
                RideInformationContent(
                    title: "Motorista",
                    description: "\(rideInformation.driver.name)"
                )
                
                RideInformationContent(
                    title: "Valor",
                    description: "\(rideInformation.value, format: .currency(code: "BRL"))"
                )
            }
        } label: {
            VStack(alignment: .leading) {
                Text(rideInformation.destination)
                
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
