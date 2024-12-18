import Foundation

class SpotifyCore {
    func handleTokenSession(_ token: SpotifyTokenResponse) -> String {
        let sessionID: String = UUID().uuidString
        TokenStorage.shared.setToken(for: sessionID, token: token)
        return sessionID
    }
}
