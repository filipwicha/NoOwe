//
//  CoffeeViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 03/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class CoffeeListViewModel {
    var coffeeList: [CoffeeViewModel] = [CoffeeViewModel]()
}

struct CoffeeViewModel {
    
    var coffee: Coffee
    
    init(coffee: Coffee){
        self.coffee = coffee
    }
    
    var name:String {
        return self.coffee.name
    }
    
    var imageURL: String {
        return self.coffee.imageURL
    }
    
    var price: Double {
        return self.coffee.price
    }
}
