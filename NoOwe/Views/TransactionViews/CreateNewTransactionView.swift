//
//  CreateNewTransactionView.swift
//  NoOwe
//
//  Created by Filip Wicha on 15/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI
//import KeyboardObserving

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
                    
                    VStack{
                        Text("Total value:").font(.subheadline)
                        Text("\(self.GT(t:.p), specifier: "%.2f") \(self.currencySymbol)").font(.headline)
                        Text("")
                        
                        Button(action: {
                        self.createTransaction()
                        }) {
                            if !(self.GT(t:.p)-self.GT(t:.n) == 0 && self.GT(t:.p) > 0 && self.newTransactionVM.title != "")
                            {
                                VStack{
                                    Text("Left to separate:").font(.subheadline).foregroundColor(.white)
                                    Text("\(self.GT(t:.p)-self.GT(t:.n), specifier: "%.2f") \(self.currencySymbol)").font(.headline).foregroundColor(.white)
                                }
                            } else {
                                Text("Create").font(.title).foregroundColor(.green)
                            }
                            
                        }
                        //                        .disabled(!(self.GT(t:.p)-self.GT(t:.n) == 0 && self.GT(t:.p) > 0 && self.newTransactionVM.title != ""))
//
//                        Text("Left to separate:").font(.subheadline)
//                        Text("\(self.GT(t:.p)-self.GT(t:.n), specifier: "%.2f") \(self.currencySymbol)").font(.headline)
                    }
                }.frame(width: 200, height: 200)
                    .padding(.bottom, 10)
                
                Text(" ")
                Picker(selection: self.$newTransactionVM.category, label: Text("Category"))
                {
                    ForEach(self.newTransactionVM.categories) { category in
                        Text(self.newTransactionVM.caregoriesEmojis[category.id])
                            .tag(category.id)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                ScrollView(.horizontal){
                    HStack{
                        VStack {
                            HStack{
                                Spacer()
                                HStack{
                                    Text("Members").font(.title).foregroundColor(.blue)
                                    Text(" are paying").font(.title)
                                }
                            }.padding(.bottom, 10)
                            ForEach(0 ..< self.newTransactionVM.shares.count) { index in
                                VStack(alignment: .leading){
                                    VStack {
                                        HStack{
                                            Spacer()
                                            Text("\(self.newTransactionVM.shares[index].nickname)'s part:").foregroundColor(.gray).font(.footnote)
                                            Spacer()
                                        }
                                        HStack{
                                            Text("               ").foregroundColor(.gray).font(.title)
                                            HStack{
                                                Text("  ")
                                                TextField( "0.0", text: self.$newTransactionVM.shares[index].positive )
                                                    .keyboardType(.decimalPad)
                                                    .font(.title)
                                                
                                                Text(" \(self.currencySymbol)").foregroundColor(.gray).font(.title)
                                                Text("  ")
                                            }.overlay(RoundedRectangle(cornerRadius: 2) .stroke(Color.gray, lineWidth: 1)).padding(.bottom, 5)
                                        }
                                    }
                                }.padding(.bottom, 3)
                            }
                            
                            
                            Spacer()
                        }
                        .frame(width: geometry.size.width-140, height: self.maxHeight, alignment: .topLeading)
                        .padding(6)
                        
                        Button(action:{}){
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                        //
                        VStack{
                            HStack{
                                Text("for ").font(.title)
                                Text( "\(self.newTransactionVM.title == "" ? "***" : self.newTransactionVM.title.lowercased())").font(.title).foregroundColor(.blue)
                            }.padding(.bottom, 10)
                            
                            HStack{
                                Spacer()
                                Text("Title").foregroundColor(.gray).font(.footnote)
                                Spacer()
                            }
                            HStack{
                                HStack{
                                    Spacer()
                                    TextField( "\"Chips\"", text: self.$newTransactionVM.title)
                                        .font(.title)
                                    Spacer()
                                }.overlay(RoundedRectangle(cornerRadius: 2) .stroke(Color.gray, lineWidth: 1)).padding(.bottom, 5)
                            }
                        }
                        .frame(width: (geometry.size.width)/2, height: self.maxHeight, alignment: .topLeading)
                        .padding()
                        
                        Button(action:{}){
                            Image(systemName: "arrowtriangle.right.fill")
                        }
                        
                        VStack{
                            HStack{
                                HStack{
                                    Text("for ").font(.title)
                                    Text("members' parts.").font(.title).foregroundColor(.blue)
                                }
                                Spacer()
                            }.padding(.bottom, 10)
                            ForEach(0 ..< self.newTransactionVM.shares.count) { index in
                                VStack(alignment: .leading){
                                    VStack {
                                        HStack{
                                            Spacer()
                                            Text("\(self.newTransactionVM.shares[index].nickname)'s part:").foregroundColor(.gray).font(.footnote)
                                            Spacer()
                                        }
                                        HStack{
                                            HStack{
                                                Text("  ")
                                                TextField( "0.0", text: self.$newTransactionVM.shares[index].negative )
                                                    .keyboardType(.decimalPad)
                                                    .font(.title)
                                                
                                                Text(" \(self.currencySymbol)").foregroundColor(.gray).font(.title)
                                                Text("  ")
                                            }.overlay(RoundedRectangle(cornerRadius: 2) .stroke(Color.gray, lineWidth: 1)).padding(.bottom, 5)
                                            Text("               ").foregroundColor(.gray).font(.title)
                                        }
                                    }
                                }.padding(.bottom, 3)
                            }
                        }
                        .frame(width: geometry.size.width-140, height: self.maxHeight, alignment: .top)
                        .padding(6)
                    }
                }
            }.modifier(DismissingKeyboard())
        }
    }
    
    static var g1Start = Color(red: 134.0 / 255, green: 75.0 / 255, blue: 162.0 / 255)
    static var g1End = Color(red: 191.0 / 255, green: 58.0 / 255, blue: 48.0 / 255)
    static var g2Start = Color(red:  161.0 / 255, green: 210.0 / 255, blue: 64.0 / 255)
    static var g2End = Color(red: 27.0 / 255, green: 139.0 / 255, blue: 0.0 / 255)
    static var g3Start = Color(red: 139.0 / 255, green: 147.0 / 255, blue: 154.0 / 255)
    static var g3End = Color(red: 91.0 / 255, green: 100.0 / 255, blue: 103.0 / 255)
    
    
    
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

