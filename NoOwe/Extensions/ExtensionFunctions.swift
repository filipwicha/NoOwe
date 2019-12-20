//
//  ExtensionFunctions.swift
//  NoOwe
//
//  Created by Filip Wicha on 09/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        return dateFormatter.date(from: self) ?? Date(timeIntervalSince1970: 0)
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        return dateFormatter.string(from: self)
    }
}
