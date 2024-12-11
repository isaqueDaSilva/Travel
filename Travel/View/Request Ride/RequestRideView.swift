//
//  RequestRideView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/7/24.
//

import SwiftUI

struct RequestRideView: View {
    @State private var viewModel = ViewModel()
    @State private var path = [Int]()
    
    var body: some View {
        NavigationStack(path: $path) {
            Form {
                Section("Direções") {
                    HStack {
                        directionIndicatorComponent
                        
                        directionsInserterComponent
                    }
                }
                .listRowBackground(Color.secondary.opacity(0.15))
                
                customerIdentifierInserterComponent
                    .listRowBackground(Color.secondary.opacity(0.15))
                
                makeRequestButtonComponent
            }
            .navigationTitle("Onde Vamos?")
            .scrollContentBackground(.hidden)
            .errorAlert(error: $viewModel.error)
            .navigationDestination(for: Int.self) { _ in
                if path.last == 1 {
                    ChoiceARideView(
                        path: $path,
                        rideEstimated: viewModel.ride!,
                        customerID: viewModel.customerID,
                        origin: viewModel.initialLocation,
                        destination: viewModel.destination
                    )
                } else if path.last == 2 {
                    HistoryView(path: $path)
                }
            }
        }
    }
}

extension RequestRideView {
    @ViewBuilder
    private var directionIndicatorComponent: some View {
        VStack {
            Circle()
                .fill(.gray)
                .frame(width: 5, height: 5)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(.gray.opacity(0.5))
                .frame(width: 3, height: 20)
            
            Circle()
                .fill(.gray)
                .frame(width: 5, height: 5)
        }
    }
    
    @ViewBuilder
    private var directionsInserterComponent: some View {
        VStack(alignment: .leading) {
            TextField(
                "Insira a localização inicial da corrida...",
                text: $viewModel.initialLocation
            )
            
            Divider()
            
            TextField(
                "Insira o destino final da viagem...",
                text: $viewModel.destination
            )
        }
    }
    
    @ViewBuilder
    private var customerIdentifierInserterComponent: some View {
        Section {
            TextField(
                "Insira aqui seu id...",
                text: $viewModel.customerID
            )
        } header: {
            Text("Identificação:")
        } footer: {
            Text("Seu id será utilizado para que possamos saber quem você é, e processar sua corrida de forma segura.")
        }
    }
    
    @ViewBuilder
    private var makeRequestButtonComponent: some View {
        ActionButton(
            isProcessing: $viewModel.isProcessing,
            title: "Escolher Motorista",
            isDisabled: viewModel.isDisabled,
            action: {
                viewModel.makeRideRequest {
                    path.append(1)
                }
            }
        )
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
    }
}
#Preview {
    RequestRideView()
}
