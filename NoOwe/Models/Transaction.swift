//
//  Transaction.swift
//  NoOwe
//
//  Created by Filip Wicha on 09/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct Transaction: Codable, Identifiable {
    
    let id: Int
    let title: String
    let date: Date
    let budget_id: Int
    let category_id: Int
}
