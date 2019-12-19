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
        self.budgetListViewModel.fetchBudgets()
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List {
                    ForEach(self.budgetListViewModel.budgets){ budget in
                        NavigationLink(destination: TransactionListView(budget: budget)){
                            HStack{
                                ZStack{
                                    Circle()
                                        .fill(self.getColor(colorString: budget.color))
                                    Text(budget.name.prefix(1)).bold().font(.largeTitle)
                                }.frame(width: 80, height: 80)
                                
                                Text(budget.name).font(.title).bold().padding(12)
                            }
                        }
                    }
                }
            }
                
            .navigationBarTitle("Budgets")
            .navigationBarItems(
                leading:
                Button(action: {
                    KeychainWrapper.standard.set("", forKey: "email")
                    KeychainWrapper.standard.set("", forKey: "password")
                    KeychainWrapper.standard.set("", forKey: "jwtToken")
                    KeychainWrapper.standard.set("", forKey: "expiresIn")
                }){
                    HStack{
                        Image(systemName: "minus").foregroundColor(Color.white)
                    }
                },
                trailing:
                HStack{
                    Button(action:{
                        self.budgetListViewModel.fetchBudgets()
                    }){
                        Image(systemName: "arrow.clockwise").foregroundColor(Color.white)
                    }
                    Text("  ")
                    Button(action:{
                        self.showNewBudgetModal()
                    }){
                        HStack{
                            Image(systemName: "plus").foregroundColor(Color.white)
                        }
                    }
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
    
    func getColor(colorString: String) -> Color {
        let hueArray: [String] = colorString.components(separatedBy: ",")
        let full = Double(255)
        
        let r = Double(hueArray[0])!/full
        let g = Double(hueArray[1])!/full
        let b = Double(hueArray[2])!/full
        
        return Color(red: r, green: g, blue: b)
    }
}

#if DEBUG
struct BudgetListView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetListView()
        
    }
}
#endif
