//
//  Coffee.swift
//  NoOwe
//
//  Created by Filip Wicha on 02/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct Coffee {
    let name: String
    let imageURL: String
    let price:Double
}

extension Coffee {
    
    static func all() -> [Coffee] {
        return [
            Coffee(name:"Cappuccino", imageURL: "Cappuccino", price: 2.5),
            Coffee(name:"Espresso", imageURL: "Espresso", price: 2.1),
            Coffee(name:"Regular", imageURL: "Regular", price: 1.0)
                ]
    }
}
