//
//  homeassistant.swift
//  HaTrmnlVapor
//
//  Created by Erik Sargent on 8/8/25.
//

import Vapor


enum HomeAssistant {
	struct State: Content {
		var entityId: String
		var state: String
	}

	enum HAError: Error {
		case invalidURL
		case badType
	}

	static func getStates(client: any Client) async throws -> [State] {
		guard let baseUrl = Environment.get("HA_URL") else { throw HAError.invalidURL }
		let uri = URI(string: "\(baseUrl)/api/states")

		print(uri)
		let headers = HTTPHeaders([
			("Authorization", "\(Environment.get("HA_BEARER") ?? "")"),
			("Content-Type", "application/json")
		])
		let response = try await client.get(uri, headers: headers)
		print(response)

		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let states = try response.content.decode([State].self, using: decoder)

		return states
	}
}


extension HomeAssistant.State {
	func number(precision: Int, scale: Double? = nil, addUnit unit: String? = nil) throws -> String {
		guard var value = Double(self.state) else {
			throw HomeAssistant.HAError.badType
		}

		if let scale {
			value *= scale
		}

		var formatted = String(format: "%.\(precision)f", value)
		if let unit {
			formatted += unit
		}

		return formatted
	}
	
	func double(scale: Double? = nil) throws -> Double {
		guard var value = Double(self.state) else {
			throw HomeAssistant.HAError.badType
		}

		if let scale {
			value *= scale
		}

		return value
	}

	func capitalized() -> String {
		return self.state.capitalized
	}
}


extension Sequence where Element == HomeAssistant.State {
	func entity(id: String) -> HomeAssistant.State? {
		return self.first(where: { $0.entityId == id })
	}
}
