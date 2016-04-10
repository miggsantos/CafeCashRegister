//
//  AddedItem.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 10/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData

class AddedItem {
    
    private var _id:String!
    private var _name:String!
    private var _price:Double!
    private var _quantity:Int!
    
    var id: String {
        return _id
    }
   
    var name: String {
        get{ return _name.capitalizedString }
        set{ _name = newValue }
    }
    
    var price: Double {
        get{
            if _price == nil {
                return 0.0
            }
            return _price
        }
        set{ _price = newValue }
    }
    

    var priceWithCurrency: String {
        return "\(self._price) \(EURO)"
    }
    
    var quantity: Int {
        get{
            if _quantity == nil {
                return 1
            }
            return _quantity
        }
        set{ _quantity = newValue }
    }
    
    var nameAndQty: String {
        
        if(quantity > 1) {
            
            return _name.capitalizedString + " \(quantity)x"
        }
        else {
            return _name.capitalizedString
            
        }
    }
    
    init(objectId:String, name: String, price:Double) {
        
        self._id = objectId
        self._name = name
        self._price = price
        
    
    }
    
}