//
//  AuthView.swift
//  Travel
//
//  Created by Isaque da Silva on 11/7/25.
//

import SwiftUI

// TODO: Implement Signin view
struct AuthView: View {
    @State private var page: Page = .signin
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: Logo
                
                Form {
                    Section {
                        VStack {
                            Image(systemName: "point.topright.arrow.triangle.backward.to.point.bottomleft.filled.scurvepath")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.green)
                                .frame(maxWidth: 85, maxHeight: 85)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(lineWidth: 2)
                                }
                                .padding(.bottom, 5)
                            
                            Text("Travel")
                                .font(.largeTitle)
                                .bold()
                        }
                        .frame(maxWidth: .infinity)
                        .listRowBackground(Color.clear)
                    }
                    
                    
                    Section {
                        Picker("Action", selection: $page) {
                            ForEach(Page.allCases, id: \.id) {
                                Text($0.rawValue)
                                    .tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if page == .signup {
                            TextField("Name", text: .constant(""))
                        }
                        
                        TextField("Email", text: .constant(""))
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        
                        SecureField("Password", text: .constant(""))
                        
                        Button {
                            
                        } label: {
                            ActionButton(
                                isProcessing: $isLoading,
                                title: page.rawValue,
                                isDisabled: false
                            ) {
                                    
                            }
                        }
                    }
                }
            }
        }
    }
}

extension AuthView {
    enum Page: String, Identifiable, CaseIterable {
        case signin = "Sign In"
        case signup = "Sign Up"
        
        var id: String { self.rawValue }
    }
}

#Preview {
    AuthView()
}
