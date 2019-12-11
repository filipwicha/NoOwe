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
    var budget: BudgetViewModel
    
    init(budget: BudgetViewModel){
        self.budget = budget
        fetchTransactions()
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
}
