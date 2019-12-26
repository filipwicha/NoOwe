//
//  WebService.swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class WebService {
    let baseURL: String = "https://noowe.herokuapp.com"
    
    init(){
        
    }
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        
        jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        return jsonDecoder
    }()
    
    func register(newUser: User, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let url = URL(string: baseURL + "/auth/signup") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newUser)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Registration fetch error " + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success("Registration correct"))
            }
        }.resume()
    }
    
    func createNewBudget(newBudget: NewBudget, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let url = URL(string: baseURL + "/budget") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newBudget)
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("New budget response fetch error " + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success("New budget added correctly"))
            }
        }.resume()
    }
    
    func createNewTransaction(newTransaction: Transaction, completion: @escaping (Result<String, Error>) -> ()) {
        
        guard let url = URL(string: baseURL + "/transaction/\(newTransaction.budget_id)") else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newTransaction)
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("New transaction response fetch error " + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success("New transaction added correctly"))
            }
        }.resume()
    }
    
    func login(user: User, completion: @escaping (Result<LoginResponse, Error>) -> ()) {
        
        guard let url = URL(string: baseURL + "/auth/signin") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Login response fetch error " + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do{
                    let response = try self.jsonDecoder.decode(LoginResponse.self, from: data)
                    print("Login: " + response.accessToken)
                    
                    let dateString: String = response.expiresIn.toString()
                    
                    print(response.accessToken)
                    
                    KeychainWrapper.standard.set(user.email, forKey: "email")
                    KeychainWrapper.standard.set(user.password, forKey: "password")
                    KeychainWrapper.standard.set(response.accessToken , forKey: "jwtToken")
                    KeychainWrapper.standard.set(dateString, forKey: "expiresIn")
                    
                    completion(.success(response))
                    print("Login correct" )
                } catch let error {
                    completion(.failure(error))
                    print("Error parsing json to model LOGIN" )
                    return
                }
            }
        }.resume()
    }
    
    func getBudgets(completion: @escaping (Result<[Budget], Error>) -> ()){
        guard let url = URL(string: baseURL + "/budgets") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Error getting budgets" + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try self.jsonDecoder.decode([Budget].self, from: data)
                    completion(.success(response))
                    print("Got budgets correctly \(self.getId())" )
                } catch let error {
                    completion(.failure(error))
                    print("Error parsing json to budget model" )
                    
                    return
                }
            }
        }.resume()
    }
    
    func getTransactions(budgetId: Int, completion: @escaping (Result<[Transaction], Error>) -> ()){
        guard let url = URL(string: baseURL + "/transactions/\(budgetId)") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Error getting transactions" + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try self.jsonDecoder.decode([Transaction].self, from: data)
                    completion(.success(response))
                    print("Got transactions correctly \(self.getId())" )
                } catch let error {
                    completion(.failure(error))
                    print("Error parsing json to transaction model" )
                    return
                }
            }
        }.resume()
    }
    
    func getBudgetMembers(budgetId: Int, completion: @escaping (Result<[BudgetMember], Error>) -> ()){
        guard let url = URL(string: baseURL + "/budget_members/\(budgetId)") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Error getting budget members" + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try self.jsonDecoder.decode([BudgetMember].self, from: data)
                    completion(.success(response))
                    print("Got budget members correctly" )
                } catch let error {
                    completion(.failure(error))
                    print("Error parsing json to budgetMember model" )
                    
                    return
                }
            }
        }.resume()
    }
    
    
    func getCurrencies(completion: @escaping (Result<[Currency], Error>) -> ()){
        guard let url = URL(string: baseURL + "/currencies") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Error getting currencies" + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try self.jsonDecoder.decode([Currency].self, from: data)
                    completion(.success(response))
                    print("Got currencies correctly" )
                } catch let error {
                    completion(.failure(error))
                    print("Error parsing json to currencies model" )
                    
                    return
                }
            }
        }.resume()
    }
    
    func getCategories(completion: @escaping (Result<[Category], Error>) -> ()){
        guard let url = URL(string: baseURL + "/categories") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Error getting categories" + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    let response = try self.jsonDecoder.decode([Category].self, from: data)
                    completion(.success(response))
                    print("Got categoires correctly" )
                } catch let error {
                    completion(.failure(error))
                    print("Error parsing json to categories model" )
                    
                    return
                }
            }
        }.resume()
    }
    
    func deleteBudget(budgetId: Int, completion: @escaping (Result<String, Error>) -> ()){
        guard let url = URL(string: baseURL + "/budget/\(budgetId)") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Deleted budget error " + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success("Deleted budget"))
            }
        }.resume()
    }
    
    func deleteTransaction(transactionId: Int, completion: @escaping (Result<String, Error>) -> ()){
        guard let url = URL(string: baseURL + "/transaction/\(transactionId)") else {
            //completion(.failure(fatalError("Wrong url")))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    print("Deleted transaction error " + error!.localizedDescription )
                    completion(.failure(error!))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(.success("Deleted transaction"))
            }
        }.resume()
    }
    
    func becomeMemberOfBudget (privateKey: String, completion: @escaping (Result<String, Error>) -> ()) {
        guard let url = URL(string: baseURL + "/budget_member/\(privateKey)") else {
            //completion(.failure(fatalError("Wrong url")))
            print("error in url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(getToken(), forHTTPHeaderField: "x-access-token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                    print("Error becoming member" + error!.localizedDescription )
                }
                return
            }
            
            DispatchQueue.main.async {
                do {
                    completion(.success("Became a budgetMember"))
                    print("Became a member" )
                } catch let error {
                    completion(.failure(error))
                    
                    return
                }
            }
        }.resume()
    }
    
    func getToken() -> String {
        var jwtToken: String = ""
        
        let dateString: String = KeychainWrapper.standard.string(forKey: "expiresIn") ?? ""
        
        if (dateString.toDate() > Date()){
            return KeychainWrapper.standard.string(forKey: "jwtToken") ?? ""
        } else {
            let user: User = User(email: KeychainWrapper.standard.string(forKey: "email")!, password: KeychainWrapper.standard.string(forKey: "password")!)
            
            login(user: user) { response in
                switch response {
                case .success(_):
                    jwtToken = KeychainWrapper.standard.string(forKey: "jwtToken")!
                    
                case .failure(_):
                    jwtToken = ""
                }
            }
            
            return jwtToken
        }
    }
    
    func getId() -> Int{
        return Int.random(in: 0 ..< 10)
    }
}


