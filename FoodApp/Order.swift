//
//  Order.swift
//  FoodApp
//
//  Created by Shaun Heffernan on 5/25/24.
//

import Foundation
@Observable
class Order: Codable {
    
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestsEnabled = "specialRequestsEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
        case _city = "city"
    }
    
    static let types = ["Vanilla","Strawberry","Chocolate","Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestsEnabled = false {
        didSet{
            if(specialRequestsEnabled == false){
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = UserDefaults.standard.string(forKey: "name") ?? "" {
          didSet {
              UserDefaults.standard.setValue(name, forKey: "name")
          }
      }

      var streetAddress = UserDefaults.standard.string(forKey: "streetAddress") ?? "" {
          didSet {
              UserDefaults.standard.setValue(streetAddress, forKey: "streetAddress")
          }
      }

      var city = UserDefaults.standard.string(forKey: "city") ?? "" {
          didSet {
              UserDefaults.standard.setValue(city, forKey: "city")
          }
      }

      var zip = UserDefaults.standard.string(forKey: "zip") ?? "" {
          didSet {
              UserDefaults.standard.setValue(zip, forKey: "zip")
          }
      }
        
    
    var hasValidAddress: Bool {
        if(name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty){
            return false
        }
        if(streetAddress.trimmingCharacters(in: .whitespaces) == ""){
            return false
        }
        
        
        return true
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        
        cost += Decimal(type) / 2
        
        if(extraFrosting){
            cost += Decimal(quantity)
        }
        
        if(addSprinkles){
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
    
}
