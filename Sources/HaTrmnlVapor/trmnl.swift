//
//  trmnl.swift
//  HaTrmnlVapor
//
//  Created by Erik Sargent on 8/8/25.
//

import Vapor


struct OverviewSlide: Content {
	var mainstogridEnergyToday: String
	var mainsfromgridEnergyToday: String
	var inverterOutput: String
	var totalSolarDailyYield: String
	var batteryPercentage: String
	var batteryState: String
	var outdoorHumidity: String
	var outdoorTemperature: String
	var windGustStrength: String
	var windSpeed: String
	var rainLastHour: String
	var rainToday: String
	
	static func makeFromStates(_ states: [HomeAssistant.State]) throws -> OverviewSlide {
		Self.init(
			mainstogridEnergyToday:
				try states.entity(id: "sensor.mainstogrid_energy_today")?
				.number(precision: 2, addUnit: "kWh") ?? "",
			mainsfromgridEnergyToday:
				try states.entity(id: "sensor.mainsfromgrid_energy_today")?
				.number(precision: 2, addUnit: "kWh") ?? "",
			inverterOutput:
				try states.entity(id: "sensor.total_inverter_grid_power")?
				.number(precision: 2, scale: 1.0 / 1000, addUnit: "kW") ?? "",
			totalSolarDailyYield:
				try states.entity(id: "sensor.total_solar_daily_yield")?
				.number(precision: 2, scale: 1.0 / 1000, addUnit: "kWh") ?? "",
			batteryPercentage:
				try states.entity(id: "sensor.sonnenbatterie_156865_state_battery_percentage_user")?
				.number(precision: 0, addUnit: "%") ?? "",
			batteryState:
				states.entity(id: "sensor.sonnenbatterie_156865_state_sonnenbatterie")?
				.capitalized() ?? "",
			outdoorHumidity:
				try states.entity(id: "sensor.weather_station_outdoor_module_humidity")?
				.number(precision: 0, addUnit: "%") ?? "",
			outdoorTemperature:
				try states.entity(id: "sensor.weather_station_outdoor_module_temperature")?
				.number(precision: 1, addUnit: "ºF") ?? "",
			windGustStrength:
				try states.entity(id: "sensor.weather_station_smart_anemometer_gust_strength")?
				.number(precision: 1, addUnit: "mph") ?? "",
			windSpeed:
				try states.entity(id: "sensor.weather_station_smart_anemometer_wind_speed")?
				.number(precision: 1, addUnit: "mph") ?? "",
			rainLastHour:
				try states.entity(id: "sensor.weather_station_smart_rain_gauge_precipitation_last_hour")?
				.number(precision: 3, addUnit: "in") ?? "",
			rainToday:
				try states.entity(id: "sensor.weather_station_smart_rain_gauge_precipitation_today")?
				.number(precision: 3, addUnit: "in") ?? ""
		)
	}
}
