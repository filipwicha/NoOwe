//
//  RegisterViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 05/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class NewBudgetViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var color: String = ""
    @Published var currencyId: Int = 0
    
    @Published var numberOfMembers: Int = 0
    @Published var budgetMembers: [Nickname] = []
    @Published var currencies: [CurrencyViewModel] = []
    @Published var colors: [String] = ["211,47,47","194,24,91","123,31,162","69,39,160","40,53,147","25,118,210","0,105,92","249,168,37","216,67,21"]
    
    @Published var message = "Fill the form to create new budget"
    @Published var creationCompleated = false
    
    var webService: WebService
    
    init() {
        self.webService = WebService()
        self.fetchCurrencies()
        self.color = self.colors[Int.random(in: 0 ..< colors.count)]
    }
    
    func addNewBudgetMember(){
        self.budgetMembers.append(Nickname(id: self.budgetMembers.count, name: ""))
    }
    
    func addNewBudget() {
        print(self.budgetMembers.map({ (member) -> String in
            return member.name
        }))
        
        self.webService.createNewBudget(newBudget: NewBudget(
            name: self.name,
            color: self.color,
            currency_id: self.currencyId,
            budget_members:  self.budgetMembers.map({ (member) -> String in
                return member.name
            })))
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
    
    func fetchCurrencies(){
        
        WebService().getCurrencies { response in
            switch response {
                
            case .success(let currencies):
                self.currencies = currencies.map(CurrencyViewModel.init)
            case .failure(let error):
                print("Error " + error.localizedDescription)
            }
        }
    }
    
    struct Nickname: Identifiable {
        var id: Int
        var name: String
    }
}

class CurrencyViewModel: Identifiable {
    
    var currency: Currency
    
    init(currency: Currency){
        self.currency = currency
    }
    
    var id: Int {
        return self.currency.id
    }
    
    var code: String {
        return self.currency.code
    }
}
