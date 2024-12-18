import Vapor

struct SpotifyHandler: RouteCollection {
    let spotifyCore: SpotifyCore = SpotifyCore()

    func boot(routes: any Vapor.RoutesBuilder) throws {
        let spotifyRoutes = routes.grouped("v1", "spotify")

        spotifyRoutes.get("playlists", use: fetchPlaylists)
    }

    func fetchPlaylists(req: Request) async throws -> Response {
        //somehow get the sessionID
        let sessionID: String? = req.headers.first(name: "X-Session-ID") ?? nil

        if let sessionID = sessionID {
            let a: [SpotifyPlaylist] = await spotifyCore.getPlaylists(sessionID)
        } else {
            throw Abort(.badRequest)  //handle error
        }
        return Response()
    }
}
