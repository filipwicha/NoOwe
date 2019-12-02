//
//  WeatherService.swift
//  NoOwe
//
//  Created by Filip Wicha on 02/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class WeatherService{
    
    func getWeather(city: String, completion: @escaping (Weather?)->()){
        
        guard let url = URL(string:"http://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=371414e553c2ae64641ed81cd3f08fc8&units=imperial")
        else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else{
                completion(nil)
                return
            }
            
            let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: data)
            
            if let weatherResponse = weatherResponse{
                let weather = weatherResponse.main
                completion(weather)
            } else {
                completion(nil)
            }
            
        }.resume()
    }
}
