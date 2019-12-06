//
//  BudgetListViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class BudgetListViewModel: ObservableObject {
    
    @Published var budgets = [BudgetViewModel]()
    
    init(){
        fetchBudgets()
    }
    
    func fetchBudgets() {
        
        WebService().getBudgets { budgets in
            if let budgets = budgets {
                self.budgets = budgets.map(BudgetViewModel.init)
            }
        }
    }
}

class BudgetViewModel {
    
    var budget: Budget
    
    init(budget: Budget){
        self.budget = budget
    }
    
    var id: Int {
        return self.budget.id
    }
    
    var name: String {
        return self.budget.name
    }
    
    var ownerId: Int {
        return self.budget.owner_id
    }
    
    var currency: Int {
        return self.budget.currency_id
    }
}
