//
//  NewTransactionViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 15/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class NewTransactionViewModel: ObservableObject {
    @Published var budgetMemberListVM: BudgetMemberListViewModel
    @Published var budgetVM: BudgetViewModel
    
    @Published var title: String = ""
    @Published var category: Int = 0
    
    @Published var shares: [(memberId: Int, nickname: String, positive: String, negative: String)] = []
    
    @Published var categories: [CategoryViewModel] = []
    @Published var message = "Fill the form to create new transaction"
    @Published var creationCompleated = false
    
    var webService: WebService = WebService()
    
    init(budgetVM: BudgetViewModel, budgetMemberListVM: BudgetMemberListViewModel) {
        self.budgetVM = budgetVM
        self.budgetMemberListVM = budgetMemberListVM
        
        self.shares = budgetMemberListVM.budgetMembers.map {
            (memberId: $0.id, nickname: $0.nickname, positive: "", negative: "")
        }
        
        self.fetchCategories()
    }
    
    func addNewTransaction() {
        var shareViewModels: [ShareViewModel] = []
        
        self.shares.forEach { share in
            let sharePositiveValue: Double = Double(share.positive) ?? 0.0
            let shareNegativeValue: Double = Double(share.negative) ?? 0.0
            
            shareViewModels.append(ShareViewModel(share: Share(id: -1, amount: sharePositiveValue, member_id: share.memberId, transaction_id: -1)))
            shareViewModels.append(ShareViewModel(share: Share(id: -1, amount: shareNegativeValue * -1, member_id: share.memberId, transaction_id: -1)))
        }
        
        self.webService.createNewTransaction(newTransaction: Transaction(
            id: -1,
            title: title,
            date: Date(),
            budget_id: budgetVM.id,
            category_id: self.categories.filter { $0.id == self.category }[0].id,
            shares: shareViewModels.map {$0.share}
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
    
    var emoji: String {
        return self.category.emoji
    }
}
