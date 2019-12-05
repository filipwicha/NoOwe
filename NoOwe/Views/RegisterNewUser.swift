//
//  RegisterNewUser().swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct RegisterNewUser: View {
    @Environment(\.presentationMode) var showModal: Binding<PresentationMode>
    @ObservedObject private var registerNewUserVM = RegisterNewUserViewModel()
    
    var body: some View {
        VStack{
            VStack {
                Form {
                    Section(header: Text("Enter email address")) {
                        TextField("email@email.com", text: self.$registerNewUserVM.email)
                    }
                    Section(header: Text("Enter password"), footer: Text(self.registerNewUserVM.message)
                    ){
                        SecureField("password", text: self.$registerNewUserVM.password)
                        SecureField("repeat", text: self.$registerNewUserVM.repeatedPassword)
                    }
                }
            }
            
            
            
            Button(action: {
                self.registerNewUserVM.registerUser()
                if(self.registerNewUserVM.registered) {
                    self.showModal.wrappedValue.dismiss()
                }
            }) {
                Text("Register!")
            }
        }
    }
}

struct RegisterNewUser_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNewUser()
    }
}
