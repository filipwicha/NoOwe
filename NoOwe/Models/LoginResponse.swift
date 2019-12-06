//
//  LoginResponse.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    
    let auth: Bool
    let expiresIn: Date
    let accessToken: String
    let id: Int
    
    let reason: String
}
