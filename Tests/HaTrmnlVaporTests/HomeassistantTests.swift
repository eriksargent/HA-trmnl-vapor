//
//  HomeassistantTests.swift
//  HaTrmnlVapor
//
//  Created by Erik Sargent on 8/25/25.
//

@testable import HaTrmnlVapor
import VaporTesting
import Testing


@Suite("Homeassistant Tests")
struct HATests {
	@Test("Test HA Entity Parsing")
	func haEntityParsing() throws {
		let states = [
			HomeAssistant.State(entityId: "a", state: "1.2345"),
			.init(entityId: "b", state: "23456"),
			.init(entityId: "c", state: "hello world")
		]
		
		#expect(try states.entity(id: "a")?.number(precision: 3) == "1.234")
		#expect(try states.entity(id: "a")?.number(precision: 3, scale: 100) == "123.450")
		#expect(try states.entity(id: "a")?.number(precision: 2, addUnit: "A") == "1.23A")
		#expect(try states.entity(id: "a")?.double() == 1.2345)
		
		#expect(try states.entity(id: "b")?.number(precision: 1, scale: 1.0 / 1000, addUnit: "B") == "23.5B")
		#expect(try states.entity(id: "b")?.double(scale: 1.0 / 1000) == 23.456)
		
		#expect(states.entity(id: "c")?.capitalized() == "Hello World")
		
		#expect(throws: HomeAssistant.HAError.badType, performing: { try states.entity(id: "c")?.double() })
		#expect(throws: HomeAssistant.HAError.badType, performing: { try states.entity(id: "c")?.number(precision: 2) })
	}
}
