import Alamofire
import Vapor

class RequestHandler {

    static let shared: RequestHandler = RequestHandler()
    init() {}

    func getSpotifyPlaylists(_ token: String) async throws -> [SpotifyPlaylist] {
        let url: String = "https://api.spotify.com/v1/me/playlists"
        let headers: Alamofire.HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        var res: [SpotifyPlaylist] = []
        NetworkHandler.shared.request(url: url, headers: headers) {
            (result: Result<[SpotifyPlaylist], Error>) in
            switch result {
            case .success(let rawPlaylists):
                res = rawPlaylists
            case .failure(let error):
                print("Error to fetch playlists:", error)
            }
        }
        return res
    }
}
