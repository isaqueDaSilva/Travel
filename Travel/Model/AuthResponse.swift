struct AuthResponse: Content {
    let userProfile: GetUserDTO
    let accessToken: String
    let refreshTokenID: String
}