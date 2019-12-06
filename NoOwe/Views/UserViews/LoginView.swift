//
//  LoginView.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var showModal: Bool = false
    @ObservedObject private var loginUserViewModel = LoginUserViewModel()
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Enter email address")) {
                    TextField("email@email.com", text: self.$loginUserViewModel.email)
                }
                Section(header: Text("Enter password"), footer: Text(self.loginUserViewModel.message)
                ){
                    SecureField("password", text: self.$loginUserViewModel.password)
                }
            }
            
            Button(action: {
                self.loginUser()
            }, label: {
                Text("Login")
                
            })
            
            Button(action: {
                self.showRegistrationModal()
            }) {
                Text("Register!")
            }
    
            .sheet(isPresented: self.$showModal){
                RegisterNewUserView()
            }
        }.navigationBarTitle("Coffee Orders")
    }
    
    func showRegistrationModal(){
        self.showModal = true
    }
    
    func loginUser(){
        self.loginUserViewModel.loginUser()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
