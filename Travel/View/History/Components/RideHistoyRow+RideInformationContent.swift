//
//  RideHistoyRow+RideInformationContent.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import SwiftUI

extension RideHistoyRow {
    struct RideInformationContent: View {
        let title: String
        let description: LocalizedStringKey
        var body: some View {
            LabeledContent {
                Text(description)
            } label: {
                Text(title)
                    .bold()
            }
        }
    }
}
