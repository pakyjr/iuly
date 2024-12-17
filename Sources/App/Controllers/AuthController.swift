import Vapor

struct AuthController: RouteCollection {
    let spotifyCore: SpotifyCore = SpotifyCore()

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("v1", "auth")
        authRoutes.get("spotify", use: spotifyLoginHandler)
        authRoutes.get("callback", use: spotifyCallbackHandler)
    }

    func spotifyLoginHandler(req: Request) throws -> Response {
        let scope: String = "user-read-private user-read-email"
        let state: String = randomString(of_length: 16)

        let params: [String: String] = [
            "response_type": "code",
            "client_id": SpotifyConfig.clientID,
            "scope": scope,
            "redirect_uri": SpotifyConfig.redirectURI,
            "state": state,
        ]
        let url: String = "https://accounts.spotify.com/authorize"

        let urlWithQueryString: String = createQueryString(domain: url, parameters: params)

        return req.redirect(to: urlWithQueryString)
    }

    func spotifyCallbackHandler(req: Request) async throws -> Response {
        guard let code = req.query[String.self, at: "code"],
            let state = req.query[String.self, at: "state"]
        else {
            return req.redirect(to: "/error?message=state_mismatch")
        }

        let tokenURL: URI = URI(string: "https://accounts.spotify.com/api/token")
        let formBody: [String: String] = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": SpotifyConfig.redirectURI,
        ]
        let authHeader = HTTPHeaders([
            (
                "Authorization",
                "Basic "
                    + Data("\(SpotifyConfig.clientID):\(SpotifyConfig.clientSecret)".utf8)
                    .base64EncodedString()
            ),
            ("Content-Type", "application/x-www-form-urlencoded"),
        ])

        let tokenResponse: ClientResponse = try await req.client.post(tokenURL, headers: authHeader)
        {
            tokenRequest in
            try tokenRequest.content.encode(formBody, as: .urlEncodedForm)
        }

        if let error = try? tokenResponse.content.decode(SpotifyError.self) {
            throw Abort(.badRequest, reason: error.errorDescription)
        }

        guard let body = tokenResponse.body else {
            throw Abort(.badRequest, reason: "Empty response body from Spotify")
        }

        let tokenData: SpotifyTokenResponse = try JSONDecoder().decode(
            SpotifyTokenResponse.self, from: body)

        let sessionID: String = spotifyCore.handleTokenSession(tokenData)  //generate sessionID and store token

        print("Redirecting to /#session_id=\(sessionID)")
        return req.redirect(to: "http://localhost:8080/callback?session_id=\(sessionID)")

    }
}
