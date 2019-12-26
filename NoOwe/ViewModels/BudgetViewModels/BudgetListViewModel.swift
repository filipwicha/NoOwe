//
//  BudgetListViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class BudgetListViewModel: ObservableObject {
    
    @Published var budgets: [BudgetViewModel] = [BudgetViewModel]()
    
    init(){
        fetchBudgets()
    }
    
    func fetchBudgets() {
        
        WebService().getBudgets { response in
            switch response {
                
            case .success(let budgets):
                self.budgets = budgets.map(BudgetViewModel.init)
            case .failure(let error):
                print("Error " + error.localizedDescription)
            }
        }
    }
    
    func becomeMember(privateKey: String){
        WebService().becomeMemberOfBudget(privateKey: privateKey) { response in
            switch response {
                
            case .success(_):
                print("Became a member")
            case .failure(let error):
                print("Error " + error.localizedDescription)
            }
        }
    }
}

class BudgetViewModel: Identifiable {
    
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
    
    var color: String {
        return self.budget.color
    }
    
    var ownerId: Int {
        return self.budget.owner_id
    }
    
    var currencyId: Int {
        return self.budget.currency_id
    }
}


