//
//  WebService.swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class WebService {
    func register(newUser: User, completion: @escaping (String?) -> ()) {
        
        guard let url = URL(string: "https://noowe.herokuapp.com/auth/signup") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newUser)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else{
                DispatchQueue.main.async {
                    completion("\(String(describing: error))")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(String(data: data, encoding: .utf8))
            }
        }.resume()
    }
    
    func login(user: User, completion: @escaping (String?) -> ()) {
        
        guard let url = URL(string: "https://noowe.herokuapp.com/auth/signin") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else{
                DispatchQueue.main.async {
                    completion("\(String(describing: error))")
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(String(data: data, encoding: .utf8))
            }
        }.resume()
    }
}
