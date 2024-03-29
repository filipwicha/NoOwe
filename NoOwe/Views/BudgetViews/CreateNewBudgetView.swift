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
        NavigationView{
            VStack{
                VStack {
                    Form {
                        Section(header: Text("Enter name of the budget")) {
                            TextField("'Home budget', 'Journey' ...", text: self.$newBudgetVM.name)
                        }
                        
                        Section(
                            header: Text("Choose color")
                        ){
                            Picker(selection: self.$newBudgetVM.color, label: Text("Chosen color:").foregroundColor(self.getColor(colorString: self.newBudgetVM.color)))
                            {
                                ForEach(0 ..< self.newBudgetVM.colors.count) {
                                    Image(systemName: "square.fill")
                                        .tag(self.newBudgetVM.colors[$0])
                                        .foregroundColor(self.getColor(colorString: self.newBudgetVM.colors[$0]))
                                }
                            }
                        }
                        
                        Section(
                            header: Text("Choose currency"),
                            footer: Text(self.newBudgetVM.message)
                        ){
                            Picker(selection: self.$newBudgetVM.currencyId, label: Text("Currency")) {
                                ForEach(self.newBudgetVM.currencies.indices, id:\.self) { index in
                                    Text(self.newBudgetVM.currencies[index].code).tag(self.newBudgetVM.currencies[index].id)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
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
                        
                        
                    }
                }
                
                Button(action: {
                    self.createBudget()
                }) {
                    ButtonText(text: self.newBudgetVM.creationCompleated ? "See budgets" : "Create")
                }
            }
                
            .navigationBarItems(
                leading:
                Text(self.newBudgetVM.name == "" ? "New budget" : "Budget: ")
                    .font(.largeTitle)
                    .bold(),
                trailing:
                Text(self.newBudgetVM.name)
                    .foregroundColor(self.getColor(colorString: self.newBudgetVM.color))
                    .font(.largeTitle)
                    .bold()
                
            )
            
            
        }
    }
    
    func getColor(colorString: String) -> Color {
        let hueArray: [String] = colorString.components(separatedBy: ",")
        let full = Double(255)
        
        let r = Double(hueArray[0])!/full
        let g = Double(hueArray[1])!/full
        let b = Double(hueArray[2])!/full
        
        return Color(red: r, green: g, blue: b)
    }
    
    func createBudget(){
        if(self.newBudgetVM.creationCompleated) {
            self.hideThisModal()
        } else {
            self.newBudgetVM.addNewBudget()
            self.hideThisModal()
        }
    }
    
    func hideThisModal(){
        self.showModal.wrappedValue.dismiss()
    }
}


#if DEBUG
struct CreateNewBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewBudgetView()
    }
}
#endif
