//
//  ViewModel.swift
//  Travel
//
//  Created by Isaque da Silva on 11/14/25.
//



extension AuthView {
    @Observable
    @MainActor
    final class ViewModel {
        var name = ""
        var email = ""
        var password = ""
        
        var isLoading = false
        var currentPage: Page = .signin
        var alert: DefaultAlert? = nil
        
        var isDisabled: Bool {
            let isCoreFieldsEmpty = email.isEmpty && password.isEmpty
            let isNameEmpty = currentPage == .signup ? name.isEmpty : true
            
            return isCoreFieldsEmpty || isNameEmpty
        }
        
        func checkFields() -> Field? {
            if currentPage == .signup {
                if name.count < 2 {
                    return .name
                }
            }
            
            if !isValidEmail() {
                return .email
            } else if password.count < 8 {
                return .password
            } else {
                return nil
            }
        }
        
        func authHandler(
            authCompletation: @escaping (_ name: String?, _ email: String, _ password: String) async throws -> AuthResponse,
            storeTokens: @escaping (_ accessToken: String, _ refreshTokenID: String) throws -> Void,
            storeProfile: @escaping (GetUser) throws -> Void
        ) {
            isLoading = true
            
            Task { [weak self] in
                guard let self else { return }
                do {
                    let name = currentPage == .signup ? name : nil
                    let authResponse = try await authCompletation(name, self.email, self.password)
                    try storeTokens(authResponse.accessToken, authResponse.refreshTokenID)
                    
                    try await MainActor.run { [weak self] in
                        guard self != nil else { return }
                        try storeProfile(authResponse.userProfile)
                    }
                } catch let error as DefaultAlert {
                    await MainActor.run { [weak self] in
                        guard let self else { return }
                        self.alert = error
                    }
                }
                
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.isLoading = false
                }
            }
        }
        
        private func isValidEmail() -> Bool {
            let pattern = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
            return email.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
        }
    }
}