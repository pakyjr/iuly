import Vapor

final class TokenStorage {
    static let shared = TokenStorage()
    private var tokens: [String: SpotifyTokenResponse] = [:]  // [sessionID: token]
    private let queue = DispatchQueue(label: "com.example.tokenStorageQueue")

    private init() {}

    func setToken(for sessionID: String, token: SpotifyTokenResponse) {
        queue.async {
            self.tokens[sessionID] = token
        }
    }

    func getToken(for sessionID: String) -> SpotifyTokenResponse? {
        var token: SpotifyTokenResponse?
        queue.sync {
            if (tokens.contains { $0.key == sessionID }) {
                token = self.tokens[sessionID]!
            } else {
                token = nil
            }
        }
        return token
    }

    func removeToken(for sessionID: String) {
        queue.async {
            self.tokens.removeValue(forKey: sessionID)
        }
    }
}
