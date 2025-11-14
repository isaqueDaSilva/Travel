//
//  AuthView.swift
//  Travel
//
//  Created by Isaque da Silva on 11/7/25.
//

import SwiftUI

struct AuthView: View {
    @FocusState private var focusedField: Field?
    @State private var viewModel = ViewModel()
    
    var body: some View {
        Form {
            LogoView()
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            
            Picker("Page", selection: $viewModel.currentPage) {
                ForEach(Page.allCases, id: \.id) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .listRowBackground(Color.clear)
            .listRowInsets(.init())
            
            Section {
                if viewModel.currentPage == .signup {
                    TextField("Name", text: $viewModel.name)
                        .focused($focusedField, equals: .name)
                }
                
                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .email)
                
                SecureField("Password", text: $viewModel.password)
                    .focused($focusedField, equals: .password)
            }
            
            ActionButton(
                isProcessing: $viewModel.isLoading,
                title: viewModel.currentPage.rawValue,
                isDisabled: viewModel.isDisabled
            ) {
                focusedField = viewModel.checkFields()
                
                guard focusedField == nil else { return }
                
                viewModel.authHandler { name, email, password in
                    // TODO: Implement real logic
                    return .init(
                        userProfile: .init(
                            id: .init(),
                            name: "Mock",
                            email: "mock@gmail.com",
                            createdAt: .now
                        ),
                        accessToken: "access_token",
                        refreshTokenID: "123abc"
                    )
                } storeTokens: { accessToken, refreshTokenID in
                    // TODO: Implement logic for store token
                } storeProfile: { userProfile in
                    // TODO: Implement logic for store user profile
                }
            }
            .listRowBackground(Color.clear)
            .listRowInsets(.init())
            
        }
        .listRowBackground(Color.clear)
    }
}

extension AuthView {
    enum Page: String, Identifiable, CaseIterable {
        case signin = "Sign In"
        case signup = "Sign Up"
        
        var id: String { self.rawValue }
    }
    
    enum Field: Hashable {
        case name, email, password
    }
}

#Preview {
    AuthView()
}
