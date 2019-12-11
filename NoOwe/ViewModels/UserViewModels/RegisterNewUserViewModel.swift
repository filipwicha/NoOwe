//
//  RegisterViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class RegisterNewUserViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatedPassword: String = ""
    
    @Published var message = "Fill the form to register"
    @Published var validated = false
    @Published var registrationCompleated = false
    
    var webService: WebService
    
    init() {
        self.webService = WebService()
    }
    
    func registerUser() {
        validated = checkCredentials(email: self.email, password: self.password, repeatedPassword: self.repeatedPassword)
        
        if validated {
            let newUser = User(email: self.email, password: self.password)
            
            self.webService.register(newUser: newUser) { response in
                switch response {
                    
                case .success(let message):
                    self.message = message
                    print("Registered new user -> \(newUser.email): \(newUser.password)")
                    self.registrationCompleated = true
                case .failure(let error):
                    self.message = error.localizedDescription
                }
            }
        } else {
            print("Wrong credentials")
        }
    }
    
    func checkCredentials(email: String, password: String, repeatedPassword: String) -> Bool{
        let emailCheck: Bool = checkText(text: email, pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        
        let passwordCheck: Bool = checkText(text: password, pattern: "^(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z[0-9]]{8,}$")
        
        let passwordMatch: Bool = password == repeatedPassword
        
        if(!emailCheck && !passwordCheck) {
            self.message = "Wrong email and password"
            return false
        } else if (!emailCheck){
            self.message = "Wrong email"
            return false
        } else if (!passwordCheck && passwordMatch){
            self.message = "Password must contain at least 8 characters"
            return false
        } else if (!passwordMatch){
            self.message = "Passwords don't match"
            return false
        }
        
        return true
    }
    
    func checkText(text: String, pattern: String) -> Bool {
        let result = text.range(of: pattern, options:.regularExpression)
        
        if result == nil {
            return false
        } else {
            return true
        }
        
    }
}

class NewUserViewModel {
    var newUser: User
    
    init(newUser: User){
        self.newUser = newUser
    }
    
    var email: String {
        self.newUser.email
    }
    
    var password: String {
        self.newUser.password
    }
}
