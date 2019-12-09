//
//  RegisterNewUserView().swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct RegisterNewUserView: View {
    @Environment(\.presentationMode) var showModal: Binding<PresentationMode>
    @ObservedObject private var registerNewUserVM = RegisterNewUserViewModel()
    
    var body: some View {
        VStack{
            VStack {
                Form {
                    Section(
                    header: Text("Enter email address")) {
                        TextField("email@email.com", text: self.$registerNewUserVM.email)
                    }
                    Section(
                        header: Text("Enter password"),
                        footer: Text(self.registerNewUserVM.message)
                    ){
                        SecureField("password", text: self.$registerNewUserVM.password)
                        SecureField("re-enter password", text: self.$registerNewUserVM.repeatedPassword)
                    }
                }
            }
            
            Button(action: {
                self.registerUser()
            }) {
                self.registerNewUserVM.registrationCompleated ? Text("Ok") : Text("Register")
            }
        }
    }
    
    func registerUser(){
        self.registerNewUserVM.registerUser()
        
        self.showModal.wrappedValue.dismiss()
        
        if(self.registerNewUserVM.registrationCompleated) {
            self.hideThisModal()
        }
    }
    
    func hideThisModal(){
        self.showModal.wrappedValue.dismiss()
    }
}

struct RegisterNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNewUserView()
    }
}
