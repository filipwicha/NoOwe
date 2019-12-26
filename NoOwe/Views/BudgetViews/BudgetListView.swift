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
    
    @State private var askForKey: Bool = false
    @State private var privateKey: String = ""
    
    init(){
        self.budgetListViewModel.fetchBudgets()
    }
    
    var body: some View {
        NavigationView{
            VStack{
                List {
                    if askForKey {
                        HStack{
                            TextField("Enter code from friend", text: self.$privateKey)
                            Button(action:{
                                self.budgetListViewModel.becomeMember(privateKey: self.privateKey)
                                self.askForKey.toggle()
                                self.budgetListViewModel.fetchBudgets()
//                                self.privateKey = ""
                            }){
                                Image(systemName: "hand.thumbsup").padding(15)
                            }
                        }
                    }
                    ForEach(self.budgetListViewModel.budgets){ budget in
                        NavigationLink(destination: TransactionListView(budget: budget)){
                            ZStack{
                                RoundedRectangle(cornerRadius: 15).fill(
                                    LinearGradient(gradient: Gradient(colors: [
                                            self.getColor(colorString: "40,49,59"),
                                            self.getColor(colorString: "72,84,97")
                                        ]), startPoint: .top, endPoint: .bottom)
                                ).contextMenu {
                                    Button(action: {
                                        self.budgetListViewModel.deleteBudget(budgetId: budget.id)
                                    }) {
                                        HStack {
                                            Text("Delete")
                                            Image(systemName: "trash")
                                        }
                                    }
                                }
                                
                                HStack{
                                    ZStack{
                                        Circle()
                                            .fill(self.getColor(colorString: budget.color))
                                            .shadow(radius: 10)
                                        Text(budget.name.prefix(1)).bold().font(.largeTitle)
                                    }
                                    .frame(width: 80, height: 80)
                                    
                                    Spacer()
                                    
                                    Text(budget.name).font(.title).bold().padding(12)
                                }.padding(.init(top: 10, leading: 10, bottom: 10, trailing: 10))
                            }.padding(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
                        }
                    }
                }
            }
                
            .navigationBarTitle("Budgets")
            .navigationBarItems(
                trailing:
                HStack{
                    Button(action:{
                        self.askForKey.toggle()
                    }){
                        Image(systemName: "person.badge.plus").padding(15)
                    }
                    Button(action:{
                        self.budgetListViewModel.fetchBudgets()
                    }){
                        Image(systemName: "arrow.clockwise").padding(15)
                    }
                    Button(action:{
                        self.showNewBudgetModal()
                    }){
                        Image(systemName: "plus").padding(15)
                        
                    }
                }.foregroundColor(Color.white)
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
