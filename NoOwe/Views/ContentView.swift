
import SwiftUI

struct ContentView: View {
    
    @State private var showModal: Bool = false
    @ObservedObject private var loginUserViewModel = LoginUserViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                Form {
                    Section(header: Text("Enter email address")) {
                        TextField("email@email.com", text: self.$loginUserViewModel.email)
                    }
                    Section(header: Text("Enter password"), footer: Text(self.loginUserViewModel.message)
                    ){
                        SecureField("password", text: self.$loginUserViewModel.password)
                    }
                }
                
                Button(action: {
                    self.loginUserViewModel.loginUser()
                }, label: {
                    Text("Login")
                    
                })
                
                Button(action: {
                    self.showModal.toggle()
                }) {
                    Text("Register!")
                }
                    
                    
                    
                .sheet(isPresented: self.$showModal){
                    RegisterNewUser()
                }
            }.navigationBarTitle("Coffee Orders")
            
            
            //        NavigationView {
            //            OrderListView(orders: self.orderListVM.orders)
            //
            //            .navigationBarTitle("Coffee Orders")
            //                .navigationBarItems(leading: Button(action: reloadOrders){
            //                    Image(systemName: "arrow.clockwise")
            //                        .foregroundColor(Color.white)
            //                    }, trailing: Button(action: showAddCoffeeOrderView){
            //                        Image(systemName: "plus")
            //                            .foregroundColor(Color.white)
            //                })
            //
            //                .sheet(isPresented: self.$showModal){
            //                    AddCoffeeOrderView(isPresented: self.$showModal)
            //            }
            //        }
        }
        
        //    private func reloadOrders(){
        //        self.orderListVM.fetchOrders()
        //    }
        //
        //    private func showAddCoffeeOrderView(){
        //        self.showModal = true
        //    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
