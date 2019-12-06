//
//  WebService.swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class WebService {
    
    let jwtToken: String
    let server: String = "https://noowe.herokuapp.com"
    init(){
        self.jwtToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTgsImlhdCI6MTU3NTY0Nzk2NSwiZXhwIjoxNTkxMTk5OTY1fQ._5quNjy5MkpxEVqTa3lsDH4zmK3Mzhk4OgvH8XGdCJY"
    }
    
    func register(newUser: User, completion: @escaping (String?) -> ()) {
        
        guard let url = URL(string: server + "/auth/signup") else {
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
    
    func login(user: User, completion: @escaping (LoginResponse?) -> ()) {
        
        guard let url = URL(string: server + "/auth/signin") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else{
                let errorResponse = try? JSONDecoder().decode(LoginResponse.self, from: error as! Data)
                DispatchQueue.main.async {
                    completion(errorResponse)
                }
                return
            }
            
            let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data)
            DispatchQueue.main.async{
                completion(loginResponse!)
            }
        }.resume()
    }
    
    func getBudgets(completion: @escaping ([Budget]?) -> ()){
        guard let url = URL(string: server + "/budgets") else {
            completion(nil)
            fatalError("Invalid URL")
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(jwtToken, forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else{
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let budgets = try? JSONDecoder().decode([Budget].self, from: data)
            DispatchQueue.main.async {
                completion(budgets)
            }
        }.resume()
    }
}
