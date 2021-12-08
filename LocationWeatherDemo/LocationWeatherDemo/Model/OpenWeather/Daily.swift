//
//  Daily.swift
//  LocationWeatherDemo
//
//  Created by Герман on 22.11.21.
//

import Foundation
struct Daily : Codable {
	let dt : Int?
	let sunrise : Int?
	let sunset : Int?
	let moonrise : Int?
	let moonset : Int?
	let moon_phase : Double?
	let temp : Temp?
	let feels_like : Feels_like?
	let pressure : Int?
	let humidity : Int?
	let dew_point : Double?
	let wind_speed : Double?
	let wind_deg : Int?
	let wind_gust : Double?
	let weather : [Weather]?
	let clouds : Int?
	let pop : Double?
	let uvi : Double?

	enum CodingKeys: String, CodingKey {

		case dt = "dt"
		case sunrise = "sunrise"
		case sunset = "sunset"
		case moonrise = "moonrise"
		case moonset = "moonset"
		case moon_phase = "moon_phase"
		case temp = "temp"
		case feels_like = "feels_like"
		case pressure = "pressure"
		case humidity = "humidity"
		case dew_point = "dew_point"
		case wind_speed = "wind_speed"
		case wind_deg = "wind_deg"
		case wind_gust = "wind_gust"
		case weather = "weather"
		case clouds = "clouds"
		case pop = "pop"
		case uvi = "uvi"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		dt = try values.decodeIfPresent(Int.self, forKey: .dt)
		sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
		sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
		moonrise = try values.decodeIfPresent(Int.self, forKey: .moonrise)
		moonset = try values.decodeIfPresent(Int.self, forKey: .moonset)
		moon_phase = try values.decodeIfPresent(Double.self, forKey: .moon_phase)
		temp = try values.decodeIfPresent(Temp.self, forKey: .temp)
		feels_like = try values.decodeIfPresent(Feels_like.self, forKey: .feels_like)
		pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
		humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
		dew_point = try values.decodeIfPresent(Double.self, forKey: .dew_point)
		wind_speed = try values.decodeIfPresent(Double.self, forKey: .wind_speed)
		wind_deg = try values.decodeIfPresent(Int.self, forKey: .wind_deg)
		wind_gust = try values.decodeIfPresent(Double.self, forKey: .wind_gust)
		weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
		clouds = try values.decodeIfPresent(Int.self, forKey: .clouds)
		pop = try values.decodeIfPresent(Double.self, forKey: .pop)
		uvi = try values.decodeIfPresent(Double.self, forKey: .uvi)
	}

}
