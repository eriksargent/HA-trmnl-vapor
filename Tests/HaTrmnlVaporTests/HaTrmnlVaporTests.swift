@testable import HaTrmnlVapor
import VaporTesting
import Testing

@Suite("App Tests")
struct HaTrmnlVaporTests {
    @Test("Test main route")
    func mainRoute() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "", afterResponse: { res async throws in
                #expect(res.status == .ok)
				let data = try #require(res.body.getData(at: 0, length: res.body.readableBytes))
				let json = try #require(try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])
				print(json)
				#expect(json["mainstogrid_energy_today"] != nil)
            })
        }
    }
	
	
	@Test("Test power route")
	func powerRoute() async throws {
		try await withApp(configure: configure) { app in
			try await app.testing().test(.GET, "power", afterResponse: { res async throws in
				#expect(res.status == .ok)
				let data = try #require(res.body.getData(at: 0, length: res.body.readableBytes))
				let json = try #require(try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any])
				print(json)
				#expect(json["current_inverter_power"] != nil)
			})
		}
	}
}
