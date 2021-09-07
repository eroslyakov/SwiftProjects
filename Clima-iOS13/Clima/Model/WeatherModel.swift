//
//  WeatherModel.swift
//  Clima
//
//  Created by Rosliakov Evgenii on 27.07.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String { String(format: "%.0f", temperature) }
    var conditionIcon: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snowflake"
        case 711:
            return "smoke"
        case 701...762:
            return "cloud.fog"
        case 771:
            return "cloud.heavyrain"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        default:
            return "cloud"
        }
    }
}
