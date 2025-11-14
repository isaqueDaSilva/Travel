//
//  ActionButton.swift
//  Travel
//
//  Created by Isaque da Silva on 12/9/24.
//

import SwiftUI

struct ActionButton: View {
    @Binding var isProcessing: Bool
    let title: String
    var isDisabled: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Group {
                if isProcessing {
                    ProgressView()
                } else {
                    Text(title)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .disabled(isDisabled)
    }
}

#Preview {
    ActionButton(
        isProcessing: .constant(false),
        title: "Next",
        isDisabled: false
    ) { }.padding()
}
