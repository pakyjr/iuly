import Vapor

struct AuthController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("spotify", use: spotifyAuthHandler)
        authRoutes.get("spotify", "login", use: spotifyLoginHandler)
        authRoutes.get("auth", "callback", use: spotifyCallbackHandler)
    }

    func spotifyAuthHandler(req: Request) throws -> Response {
        return Response(status: .ok)
    }

    func spotifyLoginHandler(req: Request) throws -> Response {
        let state: String = "user-read-private user-read-email"
        let scope: String = randomString(of_length: 16)

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
        // Extract parameters from the callback
        guard let code = req.query[String.self, at: "code"],
            let state = req.query[String.self, at: "state"]
        else {
            return req.redirect(to: "/error?message=state_mismatch")
        }

        // Prepare the request to exchange the authorization code for an access token
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

        // Make the HTTP request to Spotify
        let tokenResponse: ClientResponse = try await req.client.post(tokenURL, headers: authHeader)
        {
            tokenRequest in
            try tokenRequest.content.encode(formBody, as: .urlEncodedForm)
        }

        // Decode the response
        if let error = try? tokenResponse.content.decode(SpotifyError.self) {
            throw Abort(.badRequest, reason: error.errorDescription)
        }

        let tokenData = try tokenResponse.content.decode(SpotifyTokenResponse.self)
        // Redirect user with the access token (or handle token in other ways)
        return req.redirect(to: "/#?access_token=\(tokenData.accessToken)")
    }
}
