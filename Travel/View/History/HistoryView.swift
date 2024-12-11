//
//  HistoryView.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import SwiftUI

struct HistoryView: View {
    @Binding var path: [Int]
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Form {
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
                Section("Viagens") {
                    ForEach(rideHistory.rides, id: \.internalID) { ride in
                        RideHistoyRow(rideInformation: ride)
                            .padding(.bottom)
                    }
                    .listRowInsets(EdgeInsets())
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
