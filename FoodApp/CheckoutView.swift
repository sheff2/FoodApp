//
//  CheckoutView.swift
//  FoodApp
//
//  Created by Shaun Heffernan on 5/25/24.
//

import SwiftUI

struct CheckoutView: View {
    
    var order:Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var checkoutFailed = false
    
    var body: some View {
        ScrollView{
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3){ image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    Task{
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert("Thank you!", isPresented: $showingConfirmation) {} message: {
            Text(confirmationMessage)
        }
        .alert("No internet connection", isPresented: $checkoutFailed) {}
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else{
            print("failed to encode")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
            checkoutFailed = false
        } catch {
            print("check out failed \(error.localizedDescription)")
            checkoutFailed = true
        }
        
    }
}

#Preview {
    CheckoutView(order: Order())
}
