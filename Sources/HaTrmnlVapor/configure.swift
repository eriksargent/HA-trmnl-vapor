import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	// create a new JSON encoder that uses unix-timestamp dates
	let encoder = JSONEncoder()
	encoder.keyEncodingStrategy = .convertToSnakeCase
	
	// override the global encoder used for the `.json` media type
	ContentConfiguration.global.use(encoder: encoder, for: .json)
	
    // register routes
    try routes(app)
}
