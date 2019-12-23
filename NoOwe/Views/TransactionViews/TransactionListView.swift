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
    
    let budget: BudgetViewModel
    
    init(budget: BudgetViewModel){
        self.budget = budget
        self.transactionListVM = TransactionListViewModel(budget: budget)
        //        self.setNavigationBarColor(colorString: budget.color)
        self.currencyDownload.fetchCurrencies()
    }
    
    var body: some View {
        GeometryReader { geometry in
            List{
                Section{
                    VStack{
                        Text("Summary")
                        ForEach(self.transactionListVM.budgetMemberListVM.budgetMembers){ budgetMember in
                            HStack {
                                Text(budgetMember.nickname)
                                Text("\(self.getTotalOwe(budgetMemberId: budgetMember.id), specifier: "%.2f") \(self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code)")
                            }
                        }
                    }
                }
                Section{
                    Button(action:{
                        self.showNewTransactionModal()
                    }){
                        HStack{
                            Spacer()
                            Image(systemName: "plus").resizable().frame(width: 30, height: 30)
                        }
                        .padding(12)
                    }.frame(width: geometry.size.width-30, height: 50)
                    
                    ForEach(self.transactionListVM.transactions){ transaction in
                        HStack(alignment: .center){
                            ZStack(alignment: .leading){
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(self.getColor(colorString: self.budget.color), lineWidth: 10)
                                
                                HStack {
                                    Text(transaction.title).font(.headline).padding(20)
                                    Spacer()
                                    VStack{
                                        Text("\(self.transactionListVM.getTransactionTotal(id: transaction.id), specifier: "%.2f") \(self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code)").font(.title).bold().padding(20)
                                        //  Image(systemName: transaction.categoryId)
                                    }
                                }
                            }.frame(width: geometry.size.width-30, height: 140)
                        }
                    }
                }
                
            }.sheet(isPresented: self.$showModal){
                CreateNewTransactionView(budget: self.budget, budgetMemberListVM: self.transactionListVM.budgetMemberListVM, currencySymbol: self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code, categories: self.transactionListVM.categories)
            }
                
            .navigationBarTitle("\(self.budget.name)")
            .navigationBarItems(trailing:
                Button(action:{
                    self.transactionListVM.fetchTransactions()
                }){
                    Image(systemName: "arrow.clockwise").foregroundColor(Color.white)
                }
            )
        }
    }
        func setNavigationBarColor(colorString: String){
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            UINavigationBar.appearance().backgroundColor = getColor(colorString: colorString)
        }
        
        func getColor(colorString: String) -> UIColor {
            let hueArray: [String] = colorString.components(separatedBy: ",")
            let r, g, b: CGFloat
            
            r = CGFloat(Double(hueArray[0])!/Double(255))
            g = CGFloat(Double(hueArray[1])!/Double(255))
            b = CGFloat(Double(hueArray[2])!/Double(255))
            
            return UIColor(red: r, green: g, blue: b, alpha: 1)
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
    }
    
    
    
    #if DEBUG
    struct TransactionListView_Previews: PreviewProvider {
        static var previews: some View {
            TransactionListView(budget: BudgetViewModel(budget: Budget(id: 4, name: "lkk", color: "2222", owner_id: 1, currency_id: 1)))
        }
    }
#endif
