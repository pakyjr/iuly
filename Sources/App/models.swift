import Vapor

struct SpotifyError: Content {
    let error: String
    let errorDescription: String
}

struct SpotifyTokenResponse: Content {
    let accessToken: String
    let tokenType: String
    let scope: String
    let expiresIn: Int
    let refreshToken: String
}
