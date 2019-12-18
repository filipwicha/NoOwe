//
//  CreateNewTransactionView.swift
//  NoOwe
//
//  Created by Filip Wicha on 15/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct CreateNewTransactionView: View {
    @Environment(\.presentationMode) var showModal: Binding<PresentationMode>
    @ObservedObject var newTransactionVM: NewTransactionViewModel
    let maxHeight: CGFloat = 400
    var currencySymbol: String
    
    init(budget: BudgetViewModel, budgetMemberListVM: BudgetMemberListViewModel, currencySymbol: String){
        self.newTransactionVM = NewTransactionViewModel(budgetVM: budget, budgetMemberListVM: budgetMemberListVM)
        self.currencySymbol = currencySymbol
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Text("\(self.newTransactionVM.title == "" ? "New transaction" : self.newTransactionVM.title)").font(.title)
                Text(" ").font(.headline)
                
                //                Text("Left to separate: \(self.getTogetTotal(t: .positive)tal(t: .negative), specifier: "%.2f") \(self.currencySymbol)").font(.subheadline)
                
                ZStack{
                    
                    Circle()
                    .stroke(
                        (
                            !(self.GT(t:.p)-self.GT(t:.n) == 0 && self.GT(t:.p) > 0 && self.newTransactionVM.title != "") ?
                                LinearGradient(
                                        gradient: .init(colors: [Self.g1Start, Self.g1End]),
                                        startPoint: .init(x: 0.5, y: 0),
                                        endPoint: .init(x: 0.5, y: 0.6)
                                )
                                :
                                LinearGradient(
                                    gradient: .init(colors: [Self.g2Start, Self.g2End]),
                                    startPoint: .init(x: 0.5, y: 0),
                                    endPoint: .init(x: 0.5, y: 0.6)
                                )
                        ), lineWidth: 30)
                        .rotationEffect(Angle(degrees: self.GT(t: .p)))
                        .animation(.linear)
                        
                    
//                    Circle()
//                        .fill(LinearGradient(
//                            gradient: .init(colors: [Self.g2Start, Self.g2End]),
//                            startPoint: .init(x: 0.5, y: 0),
//                            endPoint: .init(x: 0.5, y: 0.6)
//                        ))
                    
                    VStack{
                        Text("Total value:").font(.subheadline)
                        Text("\(self.GT(t:.p), specifier: "%.2f") \(self.currencySymbol)").font(.headline)
                        Text("")
                        Text("Left to separate:").font(.subheadline)
                        Text("\(self.GT(t:.p)-self.GT(t:.n), specifier: "%.2f") \(self.currencySymbol)").font(.headline)
                    }
                }.frame(width: 250, height: 250)
                
                Text(" ") 
                
                ScrollView(.horizontal){
                    HStack{
                        
                        VStack {
                            
                            HStack{
                                Spacer()
                                Text("Members are paying").font(.title)
                            }
                            Form{
                                ForEach(0 ..< self.newTransactionVM.shares.count) { index in
                                    Section(header: Text("\(self.newTransactionVM.shares[index].nickname) pays:")){
                                        TextField(
                                            "0.0",
                                            text: self.$newTransactionVM.shares[index].positive
                                        ).keyboardType(.decimalPad)
                                    }
                                }
                            }.modifier(DismissingKeyboard())
                            Spacer()
                        }
                        .frame(width: geometry.size.width-70, height: self.maxHeight, alignment: .topLeading)
                        .padding(6)
                        
                        Button(action:{}){
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                        //
                        VStack{
                            Text("for").font(.title)
                            
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
                            HStack{
                                Text("for members' parts.").font(.title)
                                Spacer()
                            }
                            Form{
                                ForEach(0 ..< self.newTransactionVM.shares.count) { index in
                                    Section(header: Text("\(self.newTransactionVM.shares[index].nickname)'s part:")){
                                        TextField(
                                            "0.0",
                                            text: self.$newTransactionVM.shares[index].negative
                                        ).keyboardType(.decimalPad)
                                    }
                                }
                            }.modifier(DismissingKeyboard())
                        }
                        .frame(width: geometry.size.width-70, height: self.maxHeight, alignment: .topLeading)
                        .padding(6)
                    }
                }
                
                Spacer()
                Button(action: {
                    self.createTransaction()
                }) {
                    self.newTransactionVM.creationCompleated ? Text("See transactions") : Text("Create")
                }.disabled(!(self.GT(t:.p)-self.GT(t:.n) == 0 && self.GT(t:.p) > 0 && self.newTransactionVM.title != ""))
            }
        }.onAppear{
            
        }
        
        
    }
    
    static var g1Start = Color(red: 134.0 / 255, green: 75.0 / 255, blue: 162.0 / 255)
    static var g1End = Color(red: 191.0 / 255, green: 58.0 / 255, blue: 48.0 / 255)
    static var g2Start = Color(red:  161.0 / 255, green: 210.0 / 255, blue: 64.0 / 255)
    static var g2End = Color(red: 27.0 / 255, green: 139.0 / 255, blue: 0.0 / 255)
    static var system = Color(red: 0.0 / 255, green: 0.0 / 255, blue: 0.0 / 255)

    
    func GT(t: TypeOfShares ) -> Double{
        if t == .p {
            return newTransactionVM.shares.map({ Double($0.positive.replacingOccurrences(of: ",", with: ".")) ?? 0.0 }).reduce(0.0, { x, y in x + y })
        } else if t == .n {
            return newTransactionVM.shares.map({ Double($0.negative.replacingOccurrences(of: ",", with: ".")) ?? 0.0 }).reduce(0.0, { x, y in x + y })
        } else {
            return  0.0
        }
    }
    
    func createTransaction(){
        if(self.newTransactionVM.creationCompleated) {
            hideThisModal()
        } else {
            self.newTransactionVM.addNewTransaction()
            hideThisModal()

        }
    }
    
    
    func hideThisModal(){
        self.showModal.wrappedValue.dismiss()
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

enum TypeOfShares {
    case p
    case n
}

struct CreateNewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewTransactionView(budget: BudgetViewModel(budget: Budget(id: 0, name: "XD", color: "111,222,111", owner_id: -1, currency_id: 1)), budgetMemberListVM: BudgetMemberListViewModel(), currencySymbol: "$")
    }
}

