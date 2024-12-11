import Vapor

struct SpotifyConfig {
    static let clientID = Environment.get("SPOTIFY_CLIENT_ID") ?? ""
    static let clientSecret = Environment.get("SPOTIFY_CLIENT_SECRET") ?? ""
    static let redirectURI = "http://localhost:8080/v1/auth/callback"
}
