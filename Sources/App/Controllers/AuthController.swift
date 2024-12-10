import Vapor

struct AuthController: RouteCollection {
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("spotify", use: spotifyAuthHandler)
    }

    func spotifyAuthHandler(req: Request) throws -> Response {
        return Response(status: .ok)
    }
}
