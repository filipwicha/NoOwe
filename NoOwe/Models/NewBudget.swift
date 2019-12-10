//
//  NewBudget.swift
//  NoOwe
//
//  Created by Filip Wicha on 10/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct NewBudget: Codable {
    
    let name: String
    let color: String
    let currency_id: Int
    
    let budget_members: [String]
}
