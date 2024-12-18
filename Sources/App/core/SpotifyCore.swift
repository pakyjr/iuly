import Foundation

class SpotifyCore {

    init() {}

    func handleTokenSession(_ token: SpotifyTokenResponse) -> String {
        let sessionID: String = UUID().uuidString
        TokenStorage.shared.setToken(for: sessionID, token: token)
        return sessionID
    }

    func getPlaylists(_ sessionID: String) async -> [SpotifyPlaylist] {
        if let token: SpotifyTokenResponse = TokenStorage.shared.getToken(for: sessionID) {
            do {
                let spotifyRawPlaylist: [SpotifyPlaylist] = try await RequestHandler.shared
                    .getSpotifyPlaylists(token.accessToken)
                print(spotifyRawPlaylist)
                return spotifyRawPlaylist
            } catch {
                print("could not fetch playlist: \(error)")
            }
        }
        return []
    }
}
