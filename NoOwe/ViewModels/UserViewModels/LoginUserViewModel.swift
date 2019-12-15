//
//  LoginUserViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class LoginUserViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var message = "Fill the fields to login"
    @Published var loginCompleated = false
    
    var webService: WebService
    
    init() {
        self.webService = WebService()
        let dateString: String? = KeychainWrapper.standard.string(forKey: "expiresIn")
        if dateString != nil {
            if dateString!.toDate() > Date() {
                loginCompleated = true
            }
        }
        
    }
    
    func loginUser() {
        let user = User(email: self.email, password: self.password)
        
        self.webService.login(user: user) { response in
            switch response {
            case .success(_):
                self.loginCompleated = true

                //TODO: set jwt as global
                print("Login completed -> \(user.email): \(user.password)")
            case .failure(let error):
                self.message = error.localizedDescription
            }
        }
        
    }
}

class userViewModel {
    var user: User
    
    init(user: User){
        self.user = user
    }
    
    var email: String {
        self.user.email
    }
    
    var password: String {
        self.user.password
    }
}
