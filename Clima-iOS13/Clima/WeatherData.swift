//
//  WeatherData.swift
//  Clima
//
//  Created by Rosliakov Evgenii on 27.07.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: MainSection
    let weather: [WeatherSection]
}

struct MainSection: Decodable {
    let temp: Double
}

struct WeatherSection: Decodable {
    let id: Int
    let description: String
}
