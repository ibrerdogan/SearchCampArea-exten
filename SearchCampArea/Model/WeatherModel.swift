//
//  WeatherModel.swift
//  SearchCampArea
//
//  Created by İbrahim Erdogan on 1.07.2022.
//

import Foundation


struct WeatherModel : Identifiable,Codable {
    let id: Int
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone : Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds : Codable {
    let all: Int
}

// MARK: - Coord
struct Coord : Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main : Codable {
    let temp, feels_like, temp_min, temp_max: Double?
    let pressure, humidity, sea_level,grnd_level: Int?
}

// MARK: - Sys
struct Sys : Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather : Codable {
    let id: Int?
    let main,description, icon: String?
}

// MARK: - Wind
struct Wind : Codable {
    let speed: Double?
    let deg: Int?
    let gust: Double?
}
