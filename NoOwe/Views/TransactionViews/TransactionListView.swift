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
        VStack{
            Text("Summary")
            ForEach(self.transactionListVM.budgetMemberListVM.budgetMembers){ budgetMember in
                HStack {
                    Text(budgetMember.nickname)
                    Text("\(self.getTotalOwe(budgetMemberId: budgetMember.id), specifier: "%.2f") \(self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code)")
                }
            }
            
            List{
                Text("test")
                ForEach(self.transactionListVM.transactions) { transaction in
                    
                    Section{
                        ZStack{
                            Text("AAA")
//                            Rectangle()
//                                .fill(.gray)
                            
                            VStack {
                                Image(self.transactionListVM.categories.filter { $0.id == transaction.categoryId }[0].photo)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)

                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(self.transactionListVM.getTransactionTotal(id: transaction.id), specifier: "%.2f") \(self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code)")
                                            .font(.headline)
                                            .foregroundColor(.secondary)
                                        Text(transaction.title)
                                            .font(.title)
                                            .fontWeight(.black)
                                            .foregroundColor(.primary)
                                            .lineLimit(3)
                                        Text(self.transactionListVM.categories.filter { $0.id == transaction.categoryId }[0].photo)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .layoutPriority(100)

                                    Spacer()
                                }
                                .padding()
                            }
                            .cornerRadius(10)
                        }
                    }
                }
            }
        }
            
        .sheet(isPresented: self.$showModal){
            CreateNewTransactionView(budget: self.budget, budgetMemberListVM: self.transactionListVM.budgetMemberListVM, currencySymbol: self.currencyDownload.currencies.filter {$0.id == self.budget.currencyId}[0].code, categories: self.transactionListVM.categories)
        }
            
        .navigationBarTitle("\(self.budget.name)")
        .navigationBarItems(trailing:
            HStack{
                Button(action:{
                    self.transactionListVM.fetchTransactions()
                }){
                    Image(systemName: "arrow.clockwise").foregroundColor(Color.white)
                }
                Button(action:{
                    self.showNewTransactionModal()
                }){
                    HStack{
                        Spacer()
                        Image(systemName: "plus").foregroundColor(Color.white)
                    }
                    .padding(12)
                }
            }
        )
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
