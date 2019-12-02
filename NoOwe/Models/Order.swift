//
//  Order.swift
//  NoOwe
//
//  Created by Filip Wicha on 02/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct Order : Codable {
    
    let name: String
    let size: String
    let coffeeName: String
    let total: Double
    
}
