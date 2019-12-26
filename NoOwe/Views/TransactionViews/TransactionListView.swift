//
//  BudgetDetailsView.swift
//  NoOwe
//
//  Created by Filip Wicha on 11/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject var transactionListVM: TransactionListViewModel
    var currencyDownload: NewBudgetViewModel = NewBudgetViewModel()
    
    @State private var showModal: Bool = false
    @State private var showKeys: Bool = false
    
    let budget: BudgetViewModel
    
    init(budget: BudgetViewModel){
        self.budget = budget
        self.transactionListVM = TransactionListViewModel(budget: budget)
        self.currencyDownload.fetchCurrencies()
    }
    
    var body: some View {
        VStack{
            Text(self.showKeys ? "Add to budget" : "Summary")
            ForEach(self.transactionListVM.budgetMemberListVM.budgetMembers){ budgetMember in
                
                HStack {
                    Text(budgetMember.nickname).frame(width: 170 , height: 50)
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).fill(
                            self.isNotOwing(budgetMemberId: budgetMember.id) ?
                                
                                LinearGradient(gradient: Gradient(colors: [
                                    self.getColor(colorString: "35,51,41"),
                                    self.getColor(colorString: "99,212,112")
                                ]), startPoint: .top, endPoint: .bottom)
                                
                                :
                                
                                LinearGradient(gradient: Gradient(colors: [
                                    self.getColor(colorString: "164,6,6"),
                                    self.getColor(colorString: "217,130,36")
                                ]), startPoint: .top, endPoint: .bottom)
                        )
                        self.showKeys ?
                            Text(budgetMember.privateKey)
                            :
                            Text("\(self.getTotalOwe(budgetMemberId: budgetMember.id), specifier: "%.2f") \(self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code)")
                    }
                    .frame(width: 170, height: 30)
                }.padding(2)
            }
            
            List{
                ForEach(self.transactionListVM.transactions) { transaction in
                    Section{
                        VStack {
                            Image(self.transactionListVM.categories.filter{ $0.id == transaction.categoryId }[0].photo)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(self.transactionListVM.getTransactionTotal(id: transaction.id), specifier: "%.2f") \(self.currencyDownload.currencies.filter{$0.id == self.budget.currencyId}[0].code)")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                    Text(transaction.title)
                                        .font(.title)
                                        .fontWeight(.black)
                                        .foregroundColor(.primary)
                                        .lineLimit(3)
                                    Text(self.transactionListVM.categories.filter{ $0.id == transaction.categoryId }[0].photo)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                }
                                .layoutPriority(100)
                                Spacer()
                            }
                            .clipped()
                            .padding()
                        }
                        .background(self.getColor(colorString: "36,36,36"))
                        .cornerRadius(10)
                    }
                }
            }
        }
            
        .sheet(isPresented: self.$showModal, onDismiss: {
            self.transactionListVM.fetchTransactions()
        }){
            CreateNewTransactionView(budget: self.budget, budgetMemberListVM: self.transactionListVM.budgetMemberListVM, currencySymbol: self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code, categories: self.transactionListVM.categories)
        }
            
        .navigationBarTitle("\(self.budget.name)")
        .navigationBarItems(trailing:
            HStack{
                Button(action: {
                    self.showKeys.toggle()
                }){
                    self.showKeys ?
                        Image(systemName: "dollarsign.circle").padding(15)
                        :
                        Image(systemName: "person.badge.plus").padding(15)
                }
                Button(action:{
                    self.transactionListVM.fetchTransactions()
                }){
                    Image(systemName: "arrow.clockwise").padding(15)
                }
                Button(action:{
                    self.showNewTransactionModal()
                }){
                    Image(systemName: "plus").padding(15)
                }
            }.foregroundColor(Color.white)
        )
    }
    
    func showNewTransactionModal() {
        self.showModal = true
    }
    
    func getColor(colorString: String) -> Color {
        let hueArray: [String] = colorString.components(separatedBy: ",")
        let full = Double(255)
        
        let r = Double(hueArray[0])!/full
        let g = Double(hueArray[1])!/full
        let b = Double(hueArray[2])!/full
        
        return Color(red: r, green: g, blue: b)
    }
    
    func getTotalOwe(budgetMemberId: Int) -> Double{
        var owe: Double = 0.0
        self.transactionListVM.transactions.forEach { transaction in
            transaction.shares.forEach { share in
                if share.member_id == budgetMemberId {
                    owe += share.amount
                }
            }
        }
        
        return owe
    }
    
    func isNotOwing(budgetMemberId: Int) -> Bool {
        if getTotalOwe(budgetMemberId: budgetMemberId) >= 0.0 {
            return true
        }
        return false
    }
    
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView(budget: BudgetViewModel(budget: Budget(id: 4, name: "lkk", color: "2222", owner_id: 1, currency_id: 1)))
    }
}
#endif
