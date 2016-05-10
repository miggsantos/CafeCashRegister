//
//  AddedItem.swift
//  CafeCashRegister
//
//  Created by Miguel Santos on 10/04/16.
//  Copyright © 2016 Miguel Santos. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AddedItem {
    
    private var _id:String!
    private var _name:String!
    private var _price:Double!
    private var _quantity:Int!
    private var _image:UIImage!
    
    var id: String {
        return _id
    }
   
    var image: UIImage {
        if _image != nil{
            return _image
        } else {
            return UIImage(named: "cafe.png")!
        }
        
        
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
    
    init(objectId:String, name: String, price:Double, image:UIImage) {
        
        self._id = objectId
        self._name = name
        self._price = price
        self._image = image

    }
    
}