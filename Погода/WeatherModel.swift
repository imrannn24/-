//
//  WeatherModel.swift
//  Погода
//
//  Created by imran on 01.09.2023.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let base: String
    let id, dt: Int
    let main: Main
    let coord: Coord
    let wind: Wind
    let sys: Sys
    let weather: [Weather]
    let visibility: Int
    let clouds: Clouds
    let timezone, cod: Int
    let name: String
    
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let humidity: Int
    let feelsLike, tempMin, tempMax, temp: Double
    let pressure, seaLevel, grndLevel: Int

    enum CodingKeys: String, CodingKey {
        case humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp, pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let id: Int
    let country: String
    let sunset, type, sunrise: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let icon: String
    let description: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

//
//{
//  "base" : "stations",
//  "id" : 524901,
//  "dt" : 1693650906,
//  "main" : {
//    "humidity" : 77,
//    "feels_like" : 17.73,
//    "temp_min" : 17.02,
//    "temp_max" : 21.16,
//    "temp" : 17.879999999999999,
//    "pressure" : 1017,
//    "sea_level" : 1017,
//    "grnd_level" : 1000
//  },
//  "coord" : {
//    "lon" : 37.617800000000003,
//    "lat" : 55.755400000000002
//  },
//  "wind" : {
//    "speed" : 1.21,
//    "deg" : 275,
//    "gust" : 1.8
//  },
//  "sys" : {
//    "id" : 9027,
//    "country" : "RU",
//    "sunset" : 1693671828,
//    "type" : 1,
//    "sunrise" : 1693622126
//  },
//  "weather" : [
//    {
//      "id" : 500,
//      "main" : "Rain",
//      "icon" : "10d",
//      "description" : "небольшой дождь"
//    }
//  ],
//  "visibility" : 10000,
//  "clouds" : {
//    "all" : 100
//  },
//  "timezone" : 10800,
//  "cod" : 200,
//  "name" : "Москва",
//  "rain" : {
//    "1h" : 0.37
//  }
//}
