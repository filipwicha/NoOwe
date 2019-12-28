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
                HStack(spacing: 0){
                    Text("Become a").font(.title).bold()
                    Text(" NoOwe ").foregroundColor(.blue).font(.title).bold()
                    Text("member").font(.title).bold()
                    }.padding()
                
                VStack(alignment: .leading){
                    Text("Password should contain at least 8 characters including:")
                    Text("- capital letter")
                    Text("- number")
                }.font(.subheadline).foregroundColor(.gray).opacity(0.6).padding()
                
                Form {
                    Section(
                    header: Text("Enter email address")) {
                        TextField("email@email.com", text: self.$registerNewUserVM.email)
                            .textContentType(.username)
                    }
                    Section(
                        header: Text("Enter password"),
                        footer: Text(self.registerNewUserVM.message)
                    ){
                        SecureField("password", text: self.$registerNewUserVM.password).textContentType(.newPassword)
                        SecureField("re-enter password", text: self.$registerNewUserVM.repeatedPassword).textContentType(.newPassword)
                    }
                }
            }
            
            Button(action: {
                self.registerUser()
            }) {
                ButtonText(text: self.registerNewUserVM.registrationCompleated ? "Login" : "Register")
            }
        }
    }
    
    func registerUser(){
        
        if(self.registerNewUserVM.registrationCompleated) {
            self.hideThisModal()
        } else {
            self.registerNewUserVM.registerUser()
        }
    }
    
    func hideThisModal(){
        self.showModal.wrappedValue.dismiss()
    }
}

#if DEBUG
struct RegisterNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNewUserView()
    }
}
#endif
