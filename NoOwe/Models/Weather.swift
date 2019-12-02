//
//  Weather.swift
//  NoOwe
//
//  Created by Filip Wicha on 02/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct WeatherResponse:Decodable{
    let main: Weather
}

struct Weather:Decodable {
    var temp: Double?
    var humidity: Double?
}
