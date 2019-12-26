//
//  BudgetMemberViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 15/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class BudgetMemberListViewModel: ObservableObject {

    @Published var budgetMembers: [BudgetMemberViewModel] = [BudgetMemberViewModel]()
    
    init(){
        
    }
    
    func fetchBudgetMembers(budgetId: Int) {
        
        WebService().getBudgetMembers(budgetId: budgetId) { response in
            switch response {
                
            case .success(let budgetMembers):
                self.budgetMembers = budgetMembers.map(BudgetMemberViewModel.init)
            case .failure(let error):
                print("Error " + error.localizedDescription)
            }
        }
    }
}

class BudgetMemberViewModel: Identifiable {

    var budgetMember: BudgetMember
    
    init(budgetMember: BudgetMember){
        self.budgetMember = budgetMember
    }
    
    init(){
        self.budgetMember = BudgetMember(id: -1, nickname: "Wrong", user_id: -1, budget_id: -1, private_key: "")
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
    
    var privateKey: String {
        return self.budgetMember.private_key
    }
}


