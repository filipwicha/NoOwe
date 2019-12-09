//
//  Budget.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct Budget: Codable, Identifiable {
    
    let id: Int
    let name: String
    let color: String
    let owner_id: Int
    let currency_id: Int
    let transactions: [Transaction]
}
