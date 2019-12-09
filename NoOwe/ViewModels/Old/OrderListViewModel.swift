//
//  OrderListViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 03/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class OrderListViewModel: ObservableObject {
    
    @Published var orders = [OrderViewModel]()
    
    init(){
        fetchOrders()
    }
    
    func fetchOrders() {
        
        CoffeeService().getAllOrders { orders in
            if let orders = orders {
                self.orders = orders.map(OrderViewModel.init)
            }
        }
    }
}

class OrderViewModel {
    
    let id = UUID()
    
    var order: Order
    
    init(order: Order){
        self.order = order
    }
    
    var name: String {
        return self.order.name
    }
    
    var size: String {
        return self.order.size
    }
    
    var coffeeName: String{
        return self.order.coffeeName
    }
    
    var total: Double {
        return self.order.total
    }
}
