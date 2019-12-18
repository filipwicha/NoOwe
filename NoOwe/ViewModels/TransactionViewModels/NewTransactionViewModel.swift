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
    
    @Published var sharesPositive: [ShareViewModel] = [] //how much did somebody pay
    @Published var sharesNegative: [ShareViewModel] = [] //how much somebody owes
    
    @Published var shares: [(memberId: Int, nickname: String, positive: String, negative: String)] = []
    
    @Published var categories: [CategoryViewModel] = []
    @Published var caregoriesEmojis: [String] = ["🐶","💅🏻","👶🏻","🍸","💻","🍕","🛩","🎓","👩‍❤️‍👨","🛍️","🏃","🍫","💩"]
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
        
        self.shares.forEach { share in
            let sharePositiveValue: Double = Double(share.positive) ?? 0.0
            let shareNegativeValue: Double = Double(share.positive) ?? 0.0
            
            sharesPositive.append(ShareViewModel(share: Share(id: -1, amount: sharePositiveValue, member_id: share.memberId, transaction_id: -1)))
            sharesNegative.append(ShareViewModel(share: Share(id: -1, amount: shareNegativeValue * -1, member_id: share.memberId, transaction_id: -1)))
        }
        
        self.webService.createNewTransaction(newTransaction: Transaction(
            id: -1,
            title: title,
            date: Date(),
            budget_id: budgetVM.id,
            category_id: self.category,
            shares: sharesPositive.map {$0.share} + sharesNegative.map {$0.share}
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
    
//    func getBudgetMemberNickname(budgetMemberId: Int) -> String {
//        var nickname:String = "Error"
//        self.budgetMembers.forEach{ budgetMember in
//            if budgetMember.id == budgetMemberId{
//                nickname = budgetMember.nickname
//            }
//        }
//
//        return nickname
//    }
//
//    func createTemplateShares() {
//        var id: Int = -1
//        budgetMembers.forEach { budgetMember in
//            self.sharesPositive.append(
//                ShareViewModel(share: Share(id: self.sharesPositive.count, amount: 0.0, member_id: budgetMember.id, transaction_id: -1))
//            )
//            self.sharesNegative.append(
//                ShareViewModel(share: Share(id: self.sharesNegative.count, amount: 0.0, member_id: budgetMember.id, transaction_id: -1))
//            )
//            id -= 1
//        }
//    }
    
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
