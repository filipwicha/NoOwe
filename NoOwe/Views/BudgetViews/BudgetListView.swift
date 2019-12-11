//
//  BudgetListView.swift
//  NoOwe
//
//  Created by Filip Wicha on 06/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import SwiftUI

struct BudgetListView: View {
    @ObservedObject var budgetListViewModel: BudgetListViewModel = BudgetListViewModel()
    @State private var showModal: Bool = false
    
    init(){
        budgetListViewModel.fetchBudgets()
    }
    
    var body: some View {
        NavigationView{
            List{ ForEach(self.budgetListViewModel.budgets){ budget in
                NavigationLink(destination: TransactionListView(budget: budget)){
                    Text(budget.name)
                }
                }
                
                Button(action:{
                    self.showNewBudgetModal()
                }){
                    HStack{
                        Spacer()
                        Image(systemName: "plus")
                        Spacer()
                        
                    }
                }
            }
                
            .navigationBarTitle("Budgets")
            .navigationBarItems(trailing:
                Button(action:{
                    self.budgetListViewModel.fetchBudgets()
                }){
                    Image(systemName: "arrow.clockwise").foregroundColor(Color.white)
                }
            )
        }.sheet(isPresented: self.$showModal,
                onDismiss: { self.budgetListViewModel.fetchBudgets() }
        ){
            CreateNewBudgetView()
        }
    }
    
    func showNewBudgetModal(){
        self.showModal = true
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
        
    }
}
