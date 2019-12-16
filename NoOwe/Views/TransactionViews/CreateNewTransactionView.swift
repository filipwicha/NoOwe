//
//  CreateNewTransactionView.swift
//  NoOwe
//
//  Created by Filip Wicha on 15/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct CreateNewTransactionView: View {
    //@Environment(\.presentationMode) var showModal: Binding<PresentationMode>
    @ObservedObject var newTransactionVM: NewTransactionViewModel
    
    let maxHeight: CGFloat = 400
    
    init(budget: BudgetViewModel){
        self.newTransactionVM = NewTransactionViewModel(budgetViewModel: budget)
    }
    
    @State var value1: String = ""
    @State var value3: String = ""
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                ScrollView(.horizontal){
                    HStack{
                        VStack{
                            Form{ //how much is paying
                                Text("How much is paying")
                                TextField("1st part", text: self.$value1)
                                TextField("1st part", text: self.$value1)
                                TextField("1st part", text: self.$value1)
                                TextField("1st part", text: self.$value1)
                                
                            }
                        }
                        .frame(width: geometry.size.width-30, height: self.maxHeight, alignment: .topLeading)
                        .padding()
                        
                        VStack{
                            Form{ //for what is paying
                                Text("For what is paying")
                                Text("2nd part")
                                
                            }
                        }
                        .frame(width: (geometry.size.width-30)/2, height: self.maxHeight, alignment: .topLeading)
                        .padding()
                        
                        VStack{
                            Form{ //for who is paying
                                Text("For who is paying")
                                TextField("3rd part", text: self.$value3)
                                TextField("3rd part", text: self.$value3)
                                TextField("3rd part", text: self.$value3)
                                TextField("3rd part", text: self.$value3)
                                
                                
                            }
                        }
                        .frame(width: geometry.size.width-30, height: self.maxHeight, alignment: .topLeading)
                        .padding()
                    }
                }
                
                Spacer()
                Button(action: {
                    self.createTransaction()
                }) {
                    self.newTransactionVM.creationCompleated ? Text("See transactions") : Text("Create")
                }
            }
        }
    }
    
    
    func createTransaction(){
        
        //self.showModal.wrappedValue.dismiss()
        
        if(self.newTransactionVM.creationCompleated) {
            hideThisModal()
        } else {
            self.newTransactionVM.addNewTransaction()
        }
    }
    
    
    func hideThisModal(){
        //self.showModal.wrappedValue.dismiss()
    }
}

struct CreateNewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTransactionView(budget: BudgetViewModel(budget: Budget(id: 0, name: "XD", color: "111,222,111", owner_id: -1, currency_id: 1)))
    }
}

