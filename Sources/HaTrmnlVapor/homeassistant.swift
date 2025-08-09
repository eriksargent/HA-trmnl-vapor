//
//  homeassistant.swift
//  HaTrmnlVapor
//
//  Created by Erik Sargent on 8/8/25.
//

import Foundation
import Vapor


enum HomeAssistant {
	struct State: Codable {
		var entityId: String
		var state: String
		var lastChanged: Date
	}
	
	enum HAError: Error {
		case invalidURL
		case badType
	}
	
	static func getStates() async throws -> [State] {
		guard let baseUrl = Environment.get("HA_URL"), let url = URL(string: "\(baseUrl)/api/states") else { throw HAError.invalidURL }
		
		print(url)
		var request = URLRequest(url: url)
		request.setValue(Environment.get("HA_BEARER"), forHTTPHeaderField: "Authorization")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpMethod = "GET"
		print(request)
		
		let (data, _) = try await URLSession.shared.data(for: request)
		
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .iso8601
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let states = try decoder.decode([State].self, from: data)
		
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
	
	func capitalized() -> String {
		return self.state.capitalized
	}
}


extension Sequence where Element == HomeAssistant.State {
	func entity(id: String) -> HomeAssistant.State? {
		return self.first(where: { $0.entityId == id })
	}
}
