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
    @Published var budgetMemberListVM: BudgetMemberListViewModel
    
    var budget: BudgetViewModel
    var categories: [CategoryViewModel] = []
    init(budget: BudgetViewModel){
        self.budget = budget
        self.budgetMemberListVM = BudgetMemberListViewModel()
        self.budgetMemberListVM.fetchBudgetMembers(budgetId: self.budget.id)
        fetchTransactions()
        fetchCategories()
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
    
    func deleteBudget(budgetId: Int){
        WebService().deleteBudget(budgetId: budgetId) { response in
            switch response {
                
            case .success(_):
                print("Deleted budget")
            case .failure(let error):
                print("Error " + error.localizedDescription)
            }
        }
    }
    
    func fetchCategories(){
        
        WebService().getCategories { response in
            switch response {
                
            case .success(let currencies):
                self.categories = currencies.map(CategoryViewModel.init)
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

