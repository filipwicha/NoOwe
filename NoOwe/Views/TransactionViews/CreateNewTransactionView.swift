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
    
    init(budget: BudgetViewModel, budgetMemberListVM: BudgetMemberListViewModel){
        self.newTransactionVM = NewTransactionViewModel(budgetVM: budget, budgetMemberListVM: budgetMemberListVM)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Spacer()
                ScrollView(.horizontal){
                    HStack{
                        
                        VStack {
                            
                            Text("Members are paying")
                            Form{
                                ForEach(0 ..< self.newTransactionVM.shares.count) { index in
                                    Section{
                                        TextField(
                                            "\(self.newTransactionVM.shares[index].nickname) pays:",
                                            text: self.$newTransactionVM.shares[index].positive
                                        ).keyboardType(.decimalPad)
                                    }
                                }
                            }.modifier(DismissingKeyboard())
                            Spacer()
                        }
                        .frame(width: geometry.size.width-50, height: self.maxHeight, alignment: .topLeading)
                        .padding(6)
                        
                        Button(action:{}){
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                        //
                        VStack{
                            Text("for")
                            
                            Form{ //for what is paying
                                
                                TextField("Title", text: self.$newTransactionVM.title)
                                
                            }
                        }
                        .frame(width: (geometry.size.width-30)/2, height: self.maxHeight, alignment: .topLeading)
                        .padding()
                        
                        Button(action:{}){
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                        
                        VStack{
                            Text("for members' parts.")
                            Form{
                                ForEach(0 ..< self.newTransactionVM.shares.count) { index in
                                    Section{
                                        TextField(
                                            "\(self.newTransactionVM.shares[index].nickname)'s part:",
                                            text: self.$newTransactionVM.shares[index].negative
                                        ).keyboardType(.decimalPad)
                                    }
                                }
                            }.modifier(DismissingKeyboard())
                        }
                        .frame(width: geometry.size.width-50, height: self.maxHeight, alignment: .topLeading)
                        .padding(6)
                    }
                }
                
                Spacer()
                Button(action: {
                    self.createTransaction()
                }) {
                    self.newTransactionVM.creationCompleated ? Text("See transactions") : Text("Create")
                }
            }
        }.onAppear{
            
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

struct DismissingKeyboard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}

struct CreateNewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTransactionView(budget: BudgetViewModel(budget: Budget(id: 0, name: "XD", color: "111,222,111", owner_id: -1, currency_id: 1)), budgetMemberListVM: BudgetMemberListViewModel())
    }
}

