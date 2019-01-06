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
    
    fileprivate var _id:String!
    fileprivate var _name:String!
    fileprivate var _price:Double!
    fileprivate var _quantity:Int!
    fileprivate var _image:UIImage!
    
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
        get{ return _name.capitalized }
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
        return "\(self.price) \(EURO)"
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
            
            return _name.capitalized + " \(quantity)x"
        }
        else {
            return _name.capitalized
            
        }
    }
    
    init(objectId:String, name: String, price:Double, image:UIImage) {
        
        self._id = objectId
        self._name = name
        self._price = price
        self._image = image

    }
    
}
