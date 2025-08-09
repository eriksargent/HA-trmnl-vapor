import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws in
		let states = try await HomeAssistant.getStates()
		print(states)
		return try OverviewSlide.makeFromStates(states)
    }
}
