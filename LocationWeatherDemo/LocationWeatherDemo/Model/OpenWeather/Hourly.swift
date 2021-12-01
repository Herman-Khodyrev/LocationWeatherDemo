//
//  Hourly.swift
//  LocationWeatherDemo
//
//  Created by Герман on 22.11.21.
//

import Foundation
struct Hourly : Codable {
	let dt : Int?
	let temp : Double?
	let feels_like : Double?
	let pressure : Int?
	let humidity : Int?
	let dew_point : Double?
	let uvi : Double?
	let clouds : Int?
	let visibility : Int?
	let wind_speed : Double?
	let wind_deg : Int?
	let wind_gust : Double?
	let weather : [Weather]?
	let pop : Double?

	enum CodingKeys: String, CodingKey {

		case dt = "dt"
		case temp = "temp"
		case feels_like = "feels_like"
		case pressure = "pressure"
		case humidity = "humidity"
		case dew_point = "dew_point"
		case uvi = "uvi"
		case clouds = "clouds"
		case visibility = "visibility"
		case wind_speed = "wind_speed"
		case wind_deg = "wind_deg"
		case wind_gust = "wind_gust"
		case weather = "weather"
		case pop = "pop"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		temp = try values.decodeIfPresent(Double.self, forKey: .temp)
		feels_like = try values.decodeIfPresent(Double.self, forKey: .feels_like)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		dew_point = try values.decodeIfPresent(Double.self, forKey: .dew_point)
		uvi = try values.decodeIfPresent(Double.self, forKey: .uvi)
		clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
		visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
		wind_speed = try values.decodeIfPresent(Double.self, forKey: .wind_speed)
		wind_deg = try values.decodeIfPresent(Int.self, forKey: .wind_deg)
		wind_gust = try values.decodeIfPresent(Double.self, forKey: .wind_gust)
		weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
		pop = try values.decodeIfPresent(Double.self, forKey: .pop)
	}

}
