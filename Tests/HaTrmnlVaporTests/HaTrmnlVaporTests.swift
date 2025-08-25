@testable import HaTrmnlVapor
import VaporTesting
import Testing

@Suite("App Tests")
struct HaTrmnlVaporTests {
    @Test("Test main route")
    func mainRoute() async throws {
        try await withApp(configure: configure) { app in
            try await app.testing().test(.GET, "", afterResponse: { res async in
                #expect(res.status == .ok)
            })
        }
    }
}
