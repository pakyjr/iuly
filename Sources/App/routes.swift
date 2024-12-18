import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: AuthController())
    try app.register(collection: SpotifyHandler())

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
