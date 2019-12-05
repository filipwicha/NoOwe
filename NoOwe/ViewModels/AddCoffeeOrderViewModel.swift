//
//  AddCoffeeOrderViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 03/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class AddCoffeeOrderViewModel: ObservableObject {
    
    var name: String = ""
    @Published var size: String = "Medium"
    @Published var coffeeName: String = ""
    
    private var coffeeService: CoffeeService
    
    var coffeeList: [CoffeeViewModel]{
        return Coffee.all().map(CoffeeViewModel.init)
    }
    
    init(){
        self.coffeeService = CoffeeService()
    }
    
    var total: Double {
        return calculateTotalPrice()
    }
    
    func placeOrder(){
        let order = Order(name: self.name, size: self.size, coffeeName: self.coffeeName, total: self.total)
        
        self.coffeeService.createCoffeeOrder(order: order){ _ in
            
            
        }
    }
    
    func priceForSize() -> Double {
        let prices = ["Small" : 2.0, "Medium" : 3.0, "Large" : 4.0]
        
        return prices[self.size]!
    }
    
    private func calculateTotalPrice() -> Double {
        let coffeeVM = coffeeList.first { $0.name == coffeeName}
        
        if let coffeeVM = coffeeVM {
            return coffeeVM.price * priceForSize()
        } else {
            return 0.0
        }
    }
}
