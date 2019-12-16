//
//  NewTransactionViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 15/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class NewTransactionViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var categoryId: Int = 0
    
    @Published var sharesPositive: [Share] = [] //how much did somebody pay
    @Published var sharesNegative: [Share] = [] //how much somebody owes

    @Published var categories = []
    
    @Published var message = "Fill the form to create new transaction"
    @Published var creationCompleated = false
    
    
    var budgetVM: BudgetViewModel
    var budgetMemberListVM: BudgetMemberListViewModel = BudgetMemberListViewModel()
    
    var webService: WebService
    
    init(budgetViewModel: BudgetViewModel) {
        self.webService = WebService()
        self.budgetVM = budgetViewModel
        
        self.fetchCategories()
        self.budgetMemberListVM.fetchBudgetMembers(budgetId: budgetVM.id)
    }
    
    func addNewTransaction() {
        
        self.webService.createNewTransaction(newTransaction: Transaction(
            id: -1,
            title: title,
            date: Date(),
            budget_id: budgetVM.id,
            category_id: categoryId,
            shares: sharesPositive + sharesNegative
            ))
        { response in
            switch response {
            case .success(let message):
                self.message = message
                self.creationCompleated = true
                
            case .failure(let error):
                self.message = error.localizedDescription
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

class CategoryViewModel: Identifiable {
    
    var category: Category
    
    init(category: Category){
        self.category = category
    }
    
    var id: Int {
        return self.category.id
    }
    
    var photo: String {
        return self.category.photo
    }
}
