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
        Group {
            if loginUserViewModel.loginCompleated {
                BudgetListView()
            } else {
                VStack{
                    Text("")
                    Text("NoOwe").font(.largeTitle).bold()
                    Image("icon").resizable().frame(width: 150.0, height: 150.0).cornerRadius(15)
                    Form {
                        
                        Section(header: Text("Enter email address")) {
                            TextField("email@email.com", text: self.$loginUserViewModel.email)
                                .textContentType(.username)
                        }
                        
                        Section(header: Text("Enter password"), footer: Text(self.loginUserViewModel.message)
                        ){
                            SecureField("password", text: self.$loginUserViewModel.password)
                                .textContentType(.password)
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
                
            }
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
