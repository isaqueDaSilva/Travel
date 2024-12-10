//
//  HistoryView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import SwiftUI

struct HistoryView: View {
    @State private var customID = ""
    @State private var selectedDriver = 1
    @State private var isProcessing = false
    @State private var rideHistory = CustomerRideHistory(
        customerID: "CT01",
        rides: [
            .init(
                id: 1,
                date: .now,
                origin: "Apple Park",
                destination: "Apple Infinity Loop",
                distance: 4,
                duration: "7:00",
                driver: .init(id: 1, name: "Tim Cook"),
                value: 10
            ),
            .init(
                id: 2,
                date: .now,
                origin: "Apple Infinity Loop",
                destination: "Apple Park",
                distance: 4,
                duration: "12:00",
                driver: .init(id: 1, name: "John Ternus"),
                value: 15
            )
        ]
    )
    
    var body: some View {
        Form {
            Section {
                TextField("Insira seu id aqui...", text: $customID)
                Picker(
                    "Selecione o ID do motorista",
                    selection: $selectedDriver
                ) {
                    ForEach(1...3, id: \.self) { driverID in
                        Text(driverID, format: .number)
                    }
                }
            }
            .listRowBackground(Color.secondary.opacity(0.15))
            
            ActionButton(
                isProcessing: $isProcessing,
                title: "Pesquisar",
                isDisabled: false
            ) {
                
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            Section("Viagens") {
                ForEach(rideHistory.rides, id: \.id) { ride in
                    RideHistoyRow(rideInformation: ride)
                        .padding(.bottom)
                }
                .listRowInsets(EdgeInsets())
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Histórico")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
