//
//  WeatherManager.swift
//  Clima
//
//  Created by Rosliakov Evgenii on 27.07.2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=d3dd848d2155e026d0ebfaaa5849a83b&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let formattedName = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(formattedName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: Double, longitude: Double) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // 1. create a URL
        guard let url = URL(string: urlString) else {
            print("invalid url")
            return
        }
        // 2. create a URLSession
        let session = URLSession(configuration: .default)
        // 3. give the session a task
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.delegate?.didFailWithError(error: error!)
            }
            
            if let safeData = data {
                if let weather = self.parseJSON(safeData) {
                    self.delegate?.didUpdateWeather(weather)
                }
            }
        }
        // 4. start the task
        task.resume()
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let city = decodedData.name
            
            return WeatherModel(conditionId: id, cityName: city, temperature: temp)
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
