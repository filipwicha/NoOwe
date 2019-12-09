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
    
    init(){
        budgetListViewModel.fetchBudgets()
    }
    
    var body: some View {
        NavigationView{
            List{
//
//                GeometryReader { g -> Text in
//                    let frame = g.frame(in: CoordinateSpace.global)
//
//                    if frame.origin.y > 250 {
//                        self.budgetListViewModel.fetchBudgets()
//                        return Text("♾")
//                    } else {
//                        return Text("↑")
//                    }
//                }
//
//
                
                ForEach(self.budgetListViewModel.budgets){ budget in
                    Text(budget.name)
                }
            }
                
            .navigationBarTitle("Budgets")
        .navigationBarItems(trailing:
            Button(action:{
                self.budgetListViewModel.fetchBudgets()
            }){
                Image(systemName: "arrow.clockwise")
            }
        )
        }
    }
}

struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
        
    }
}
