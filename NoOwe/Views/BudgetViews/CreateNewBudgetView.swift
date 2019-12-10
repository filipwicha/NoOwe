//
//  RegisterNewUserView().swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct CreateNewBudgetView: View {
    @Environment(\.presentationMode) var showModal: Binding<PresentationMode>
    @ObservedObject var newBudgetVM = NewBudgetViewModel()
    
    var body: some View {
        VStack{
            VStack {
                Form {
                    Section(header: Text("Enter name of the budget")) {
                        TextField("'Home budget', 'Journey' ...", text: self.$newBudgetVM.name)
                    }

                    Section(
                        header: Text("Choose color")
                    ){
                        TextField("1212121", text: self.$newBudgetVM.color)
                    }

                    Section(
                        header: Text("Add budget members")
                    ){
                        List{
                            Text("Me")

                            ForEach(self.newBudgetVM.budgetMembers, id:\.id) { member in
                                TextField("\(member.id + 2)'s user nickname", text: self.$newBudgetVM.budgetMembers[member.id].name)
                            }

                            Button(action: {
                                self.newBudgetVM.addNewBudgetMember()
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    
                    Section(
                        header: Text("Choose currency"),
                        footer: Text(self.newBudgetVM.message)
                    ){
                        Picker(selection: self.$newBudgetVM.currencyId, label: Text("Strength")) {
                            ForEach(self.newBudgetVM.currencies.indices, id:\.self) { index in
                                Text(self.newBudgetVM.currencies[index].code).tag(self.newBudgetVM.currencies[index].id)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            
            Button(action: {
                self.createBudget()
            }) {
                self.newBudgetVM.creationCompleated ? Text("See budgets") : Text("Create")
            }
        }
    }
    
    func createBudget(){
        self.newBudgetVM.addNewBudget()
        
        //self.showModal.wrappedValue.dismiss()
        
        if(self.newBudgetVM.creationCompleated) {
            self.hideThisModal()
        }
    }
    
    func hideThisModal(){
        self.showModal.wrappedValue.dismiss()
    }
}

struct CreateNewBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewBudgetView()
    }
}
