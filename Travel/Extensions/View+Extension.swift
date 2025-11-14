//
//  View+Extension.swift
//  Travel
//
//  Created by Isaque da Silva on 12/8/24.
//

import SwiftUI

extension View {
    /// Defines a error alert to be used when the ``ExecutionError`` will be thrown.
    /// - Parameters:
    ///   - error: A binding value to reads the current state of the error.
    ///   - action: A ViewBuilder returning the alert’s actions to be executed when an error will thrown.
    @ViewBuilder
    func errorAlert(
        error: Binding<ExecutionError?>
    ) -> some View {
        self
            .alert(
                error.wrappedValue?.title ?? "",
                isPresented: .init(get: {
                    // Reads the title and error description to check if one of those properties aren't nil.
                    // If bolth are empty and the error is nil, the value returned will be false,
                    // if bolth aren't empty and not nil the error, the value returned will be true.
                    ((error.wrappedValue?.title.isEmpty) != nil) && ((error.wrappedValue?.errorDescription.isEmpty) != nil)
                }, set: { _ in
                    // When the user taps some button of the alert the error state will be setup back as nil.
                    error.wrappedValue = nil
                })) { } message: {
                    // Displays a message when the error description will be not nil.
                    if ((error.wrappedValue?.errorDescription.isEmpty) != nil) {
                        Text(error.wrappedValue?.errorDescription ?? "Alert description currently unavailable.")
                    }
                }
    }
}
