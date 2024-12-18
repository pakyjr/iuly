import Foundation
import Vapor

struct SpotifyConfig {
    static let clientID = Environment.get("SPOTIFY_CLIENT_ID") ?? ""
    static let clientSecret = Environment.get("SPOTIFY_CLIENT_SECRET") ?? ""
    static let redirectURI = "http://localhost:8080/v1/auth/callback"
}

func randomString(of_length: Int) -> String {
    let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<of_length).map { _ in characters.randomElement()! })
}

func createQueryString(domain: String, parameters: [String: String]) -> String {
    var components = URLComponents()
    components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    return "\(domain)?\(components.query ?? "")"
}
