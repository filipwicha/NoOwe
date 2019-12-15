//
//  LoginView.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject private var loginUserViewModel: LoginUserViewModel = LoginUserViewModel()
    @State private var showModal: Bool = false
    
    var body: some View {
        ViewConditionedByLogin()
    }
    
    func ViewConditionedByLogin() -> AnyView {
        if self.loginUserViewModel.loginCompleated {
            return AnyView(BudgetListView())
        } else {
            return AnyView(
                VStack{
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
                }
            )
        }
    }
    
    func showRegistrationModal(){
        self.showModal = true
    }
    
    func loginUser(){
        self.loginUserViewModel.loginUser()
    }
}


#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
