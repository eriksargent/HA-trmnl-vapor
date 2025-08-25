import Vapor


extension Application {
	@discardableResult
	@preconcurrency
	func getTrmnl<Content: TrmnlContent>(
		_ path: PathComponent...,
		contentType: Content.Type
	) -> Route {
		self.get(path) { req async throws in
			let states = try await HomeAssistant.getStates(client: req.client)
			print(states)
			return try Content.makeFromStates(states)
		}
	}
}


func routes(_ app: Application) throws {
	app.getTrmnl(contentType: OverviewSlide.self)
	app.getTrmnl("power", contentType: PowerSlide.self)
}
