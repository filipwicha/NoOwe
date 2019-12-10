//
//  NewBudgetMember.swift
//  NoOwe
//
//  Created by Filip Wicha on 10/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct BudgetMember: Codable, Identifiable {
    
    let id: Int
    let nickname: String
    let user_id: Int
    let budget_id: Int
}
