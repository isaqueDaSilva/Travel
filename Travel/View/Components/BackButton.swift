//
//  BackButton.swift
//  Travel
//
//  Created by Isaque da Silva on 12/10/24.
//

import SwiftUI

struct BackButton: View {
    var isDisabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "chevron.left")
            Text("Back")
        }
        .disabled(isDisabled)
    }
}

#Preview {
    BackButton(isDisabled: false) { }
}
