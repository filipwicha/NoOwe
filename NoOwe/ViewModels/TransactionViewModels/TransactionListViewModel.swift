//
//  BudgetDetailsViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 11/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class TransactionListViewModel: ObservableObject {
    
    @Published var transactions: [TransactionViewModel] = [TransactionViewModel]()
    @Published var budgetMember: BudgetMemberViewModel = BudgetMemberViewModel()

    var budget: BudgetViewModel
    
    init(budget: BudgetViewModel){
        self.budget = budget
        
        fetchThisBudgetMemberId()
        fetchTransactions()
    }
    
    func getTransactionTotal(id: Int) -> Double {
        let shares = self.transactions
            .filter { $0.id == id }
            .map { $0.shares }[0]
        
        let value = shares
            .map { $0.amount > 0 ? $0.amount : 0.0}
            .reduce(0.0, +)
        
        return value
    }
    
    func fetchTransactions() {
        
        WebService().getTransactions(budgetId: budget.id) { response in
            switch response {
                
            case .success(let transactions):
                self.transactions = transactions.map(TransactionViewModel.init)
            case .failure(let error):
                print("Error " + error.localizedDescription)
            }
        }
    }
    
    func fetchThisBudgetMemberId() {
        WebService().getThisBudgetMemberId(budgetId: budget.id) { response in
                switch response {
                    
                case .success(let budgetMember):
                    self.budgetMember = BudgetMemberViewModel(budgetMember: budgetMember)
                case .failure(let error):
                    print("Error " + error.localizedDescription)
                }
            }
        }
}

class TransactionViewModel: Identifiable {
    
    var transaction: Transaction
    
    init(transaction: Transaction){
        self.transaction = transaction
    }
    
    var id: Int {
        return self.transaction.id
    }
    
    var title: String {
        return self.transaction.title
    }
    
    var date: Date {
        return self.transaction.date
    }
    
    var budgetId: Int {
        return self.transaction.budget_id
    }
    
    var categoryId: Int {
        return self.transaction.category_id
    }
    
    var shares: [Share] {
        return self.transaction.shares
    }
}

class ShareViewModel: Identifiable {

    var share: Share
    
    init(share: Share){
        self.share = share
    }
    
    var id: Int {
        return self.share.id
    }
    
    var amount: Double {
        return self.share.amount
    }
    
    var memberId: Int {
        return self.share.member_id
    }
    
    var transactionId: Int {
        return self.share.transaction_id
    }
}

class BudgetMemberViewModel {

    var budgetMember: BudgetMember
    
    init(budgetMember: BudgetMember){
        self.budgetMember = budgetMember
    }
    
    init(){
        self.budgetMember = BudgetMember(id: -1, nickname: "Wrong", user_id: -1, budget_id: -1)
    }
    
    var id: Int {
        return self.budgetMember.id
    }
    
    var nickname: String {
        return self.budgetMember.nickname
    }
    
    var userId: Int {
        return self.budgetMember.user_id
    }
    
    var budgetId: Int {
        return self.budgetMember.budget_id
    }
}


