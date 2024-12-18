import Vapor

struct SpotifyError: Content {
    let error: String
    let errorDescription: String
}

struct SpotifyTokenResponse: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let expiresIn: Int
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
    }
}

struct SpotifyPlaylist: Decodable {
    let name: String
    let id: String
}
