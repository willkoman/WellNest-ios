import KeychainAccess

class TokenService {
    static let shared = TokenService()
    private let keychain = Keychain(service: "com.yourcompany.WellNestApp")

    func saveTokens(accessToken: String, refreshToken: String) {
        keychain["accessToken"] = accessToken
        keychain["refreshToken"] = refreshToken
    }

    func saveAccessToken(_ accessToken: String) {
        keychain["accessToken"] = accessToken
    }
    
    func saveRefreshToken(_ refreshToken: String) {
        keychain["refreshToken"] = refreshToken
    }
    
    func getAccessToken() -> String? {
        return keychain["accessToken"]
    }

    func getRefreshToken() -> String? {
        return keychain["refreshToken"]
    }

    func clearTokens() {
        keychain["accessToken"] = nil
        keychain["refreshToken"] = nil
    }
}
