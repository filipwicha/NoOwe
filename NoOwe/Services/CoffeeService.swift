//
//  CoffeeService.swift
//  NoOwe
//
//  Created by Filip Wicha on 02/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation


class CoffeeService{
    
    func getAllOrders(completion: @escaping ([Order]?) -> ()) {
        
        guard let url = URL(string: "https://island-bramble.glitch.me/orders") else {
            completion(nil)
            
            return
        }
        
        URLSession.shared.dataTask(with:url){ data, response, error in
            
            guard let data = data, error == nil else{
                DispatchQueue.main.async{
                    completion(nil)
                }
                return
            }
                
            let orders = try? JSONDecoder().decode([Order].self, from: data)
            DispatchQueue.main.async{
                completion(orders)
            }
            
        }.resume()
    }
}
