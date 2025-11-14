//
//  HistoryView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import SwiftUI

// TODO: Display all logged user ride history
struct HistoryView: View {
    @Binding var path: [Int]
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Form {
            
            // TODO: Remove this search section
            Section {
                TextField("Insira seu id aqui...", text: $viewModel.customID)
                Picker(
                    "Selecione o ID do motorista",
                    selection: $viewModel.selectedDriver
                ) {
                    ForEach(1...3, id: \.self) { driverID in
                        Text(driverID, format: .number)
                    }
                }
            }
            .listRowBackground(Color.secondary.opacity(0.15))
            
            // TODO: Remove this search button
            ActionButton(
                isProcessing: $viewModel.isProcessing,
                title: "Pesquisar",
                isDisabled: viewModel.isDisabled
            ) {
                viewModel.getHistory()
            }
            .listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets())
            
            if let rideHistory = viewModel.rideHistory {
                Group {
                    if rideHistory.rides.isEmpty {
                        ContentUnavailableView(
                            "Nenhuma viagem disponível",
                            systemImage: "mappin.slash",
                            description: Text("Não encontramos nenhuma viagem sua com este motorista.")
                        )
                    } else {
                        Section("Viagens") {
                            ForEach(rideHistory.rides, id: \.internalID) { ride in
                                RideHistoyRow(rideInformation: ride)
                                    .padding(.bottom)
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            
                            // TODO: Implement pagination technique to display all rides
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Histórico")
        .navigationBarBackButtonHidden()
        .errorAlert(error: $viewModel.error)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton(isDisabled: path.isEmpty) {
                    path.removeAll()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView(path: .constant([]))
    }
}
