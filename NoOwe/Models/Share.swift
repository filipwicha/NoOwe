//
//  Share.swift
//  NoOwe
//
//  Created by Filip Wicha on 11/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct Share: Codable, Identifiable {
    
    let id: Int
    let amount: Double
    let member_id: Int
    let transaction_id: Int
}
